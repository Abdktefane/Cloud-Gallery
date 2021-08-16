import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:core_sdk/error/exceptions.dart';
import 'package:core_sdk/error/failures.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/Fimber/logger_impl.dart';
import 'package:core_sdk/utils/dio/retry_interceptor.dart';
import 'package:core_sdk/utils/dio/retry_options.dart';
import 'package:core_sdk/utils/network_result.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/utils/token_interceptor.dart';
import 'package:graduation_project/features/backup/data/stores/tokens_store.dart';
import 'package:graduation_project/features/backup/networking/dio_options_utils.dart';
import 'package:graduation_project/features/backup/networking/networking_message.dart';
import 'package:graduation_project/features/backup/networking/networking_request_api.dart';
import 'package:moor/isolate.dart';

import 'base_isolate.dart';
import 'base_isolate_datasource.dart';
import 'networkink_ext.dart';

// TODO(abd): move to core sdk
// TODO(abd): implement wrap with base data

class NetworkIsolate extends BaseIsolate<RequestIsolateMessage, ResponseIsolateMessage> with NetworkApis {
  NetworkIsolate._({
    required Logger logger,
    required this.databasePort,
    required this.baseOptions,
    this.errorMapper,
    required this.interceptors,
  }) : super(logger);

  static Future<NetworkIsolate> getInstance({
    required Logger logger,
    required NetworkIsolateBaseOptions baseOptions,
    required SendPort databasePort,
    List<Interceptor>? interceptors,
    ErrorMapper? errorMapper,
  }) async {
    final isolate = NetworkIsolate._(
      logger: logger,
      baseOptions: baseOptions,
      interceptors: interceptors,
      databasePort: databasePort,
      errorMapper: errorMapper,
    );
    await isolate.init();
    return isolate;
  }

  final ErrorMapper? errorMapper;
  final NetworkIsolateBaseOptions baseOptions;
  final List<Interceptor>? interceptors;
  final SendPort databasePort;

  @override
  Future<Isolate> spawnIsolate(int id) => Isolate.spawn(
        _handleNetwrokRequest,
        InitIsolateMessage(
          id,
          callerPort: receivePort.sendPort,
          databasePort: databasePort,
          baseOptions: jsonEncode(baseOptions.toJson()),
          interceptors: interceptors,
        ),
      );

  @override
  Future<NetworkResult<T?>> request<T>({
    required METHOD method,
    required String endpoint,
    required Mapper<T?>? mapper,
    bool withAuth = true,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    dynamic data,
    ErrorMapper? errorMapper,
  }) {
    final completer = Completer<NetworkResult<T?>>();
    proccess((id) => RequestIsolateMessage(
          id,
          endpoint: endpoint,
          method: method,
          data: data,
          headers: headers,
          params: params,
          withAuth: withAuth,
        )).then(
      (ResponseIsolateMessage answer) {
        logger.d('answer in Network Isolater Wrapper $answer');
        completer.complete(answer.asNetworkResult(
          jsonResponse: answer.response,
          logger: logger,
          mapper: mapper,
          errorMapper: errorMapper,
        ));
      },
      onError: (e, StackTrace stackTrace) {
        completer.complete(
          e is ServerException
              ? NetworkError(ServerFailure(e.message))
              : NetworkError(ServerFailure(e is String ? e : 'msg_something_wrong')),
        );
      },
    );
    return completer.future;
  }
}

Future<void> _handleNetwrokRequest(dynamic message) async {
  final Logger logger = LoggerImpl();
  logger.d('Network Isolate Recive Initial Message: $message, Isolate Id:${Isolate.current.hashCode}');
  final ReceivePort receivePort = ReceivePort();
  late final GraduateDB database;
  late final TokensStoreImpl tokenStore;
  late final SendPort? callerPort;
  Dio? dio;

  // init isolate attributes
  if (message is InitIsolateMessage) {
    callerPort = message.callerPort;
    final MoorIsolate moorIsolate = MoorIsolate.fromConnectPort(message.databasePort);
    database = GraduateDB.connect(await moorIsolate.connect());
    tokenStore = TokensStoreImpl(database);
    final options = NetworkIsolateBaseOptions.fromJson(jsonDecode(message.baseOptions)).asDioBaseOptions()
      ..contentType = null;
    dio = Dio(options);
    dio.interceptors.addAll([
      RetryInterceptor(dio: dio, logger: logger, options: const RetryOptions()),
      TokenInterceptor(tokenStore),
      // ...?message.interceptors,
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        requestHeader: true,
        request: true,
      ),
    ]);
    // send init message (ready to start signal) to main isolate
    callerPort.send(ResponseIsolateMessage.init(message.id, receivePort.sendPort));
    // prepeate reciver pipeline to stream request
    receivePort.cast<RequestIsolateMessage>().listen(
      (requestMessage) => proccessNetworkIsolatorRequests(
        requestMessage,
        logger: logger,
        dio: dio!,
        callerPort: callerPort!,
      ),
      onError: (Object error, StackTrace st) {
        logger.e(
          'Network Isolate Catch Error with Proccess Message: $message, Isolate Id:${Isolate.current.hashCode}',
          stacktrace: st,
          ex: error,
        );
        callerPort?.send(ResponseIsolateMessage.error(
          message.id,
          ServerException(error.toString()),
          st: st,
        ));
      },
    );
  }
}
