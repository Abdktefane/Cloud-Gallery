import 'dart:async';
import 'dart:isolate';

import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:core_sdk/error/exceptions.dart';
import 'package:core_sdk/error/failures.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/Fimber/logger_impl.dart';
import 'package:core_sdk/utils/network_result.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project/features/backup/networking/networking_message.dart';
import 'package:graduation_project/features/backup/networking/networking_request_api.dart';

typedef ErrorMapper = String Function(Map<String, dynamic>);

// TODO(abd): implement wrap with base data
class NetworkIsolate {
  NetworkIsolate({required this.baseUrl, required this.logger, this.errorMapper});

  final ErrorMapper? errorMapper;
  final Logger logger;
  final String baseUrl;
  late final Isolate _isolate;
  late final Stream<ResponseIsolateMessage> _answerStream;
  final ReceivePort _receivePort = ReceivePort();
  late final Future<SendPort> _sendPort;
  bool _isClosed = false;
  int _currentId = -2 ^ 30;

  Future<void> init() async {
    _answerStream = _receivePort.cast<ResponseIsolateMessage>().asBroadcastStream();
    final id = _currentId++;
    _sendPort = _waitForRemotePort();
    _isolate = await Isolate.spawn(
      _handleNetwrokRequest,
      InitIsolateMessage(id, callerPort: _receivePort.sendPort, baseUrl: baseUrl),
    );
    return;
  }

  Future<SendPort> _waitForRemotePort() => _answerStream.firstWhere((it) => it.isInit).then((it) => it.callerPort!);

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
    final id = _currentId++;
    final completer = Completer<NetworkResult<T?>>();
    final futureAnswer = _answerStream.firstWhere((it) => it.id == id);
    _sendPort.then((it) => it.send(RequestIsolateMessage(
          id,
          endpoint: endpoint,
          method: method,
          data: data,
          headers: headers,
          params: params,
          withAuth: withAuth,
        )));
    futureAnswer.then((ResponseIsolateMessage answer) {
      logger.d('futureAnswer return with $answer');
      if (answer.isFailure) {
        // TODO(abd): provide stack trace
        completer.completeError(answer.error! /* , answer.stacktrace */);
      } else {
        completer.complete(_parseSuccess(answer.response!, mapper, logger));
      }
    } /* , onError: (e, StackTrace stackTrace) {
      completer.completeError(const MessengerStreamBroken(), stackTrace);
    } */
        );
    return completer.future;
  }

  NetworkResult<T?> _parseSuccess<T>(Map<String, dynamic> jsonResponse, Mapper<T?>? mapper, Logger logger) {
    try {
      if (jsonResponse is! Map && mapper == null) {
        return Success(jsonResponse as T?);
      }

      if (mapper == null) {
        return Success<T?>(null);
      }
      if (errorMapper != null || jsonResponse['message'] != null && (jsonResponse['status'] as int?) != 200) {
        throw ServerException(errorMapper?.call(jsonResponse) ?? jsonResponse['message'] ?? 'msg_something_wrong');
      }

      final value = mapper(jsonResponse);
      return Success(value);
    } catch (e) {
      logger.e('BaseDataSourceWithMapperImpl FINAL CATCH ERROR => request<$T> => ERROR = e:$e \n $jsonResponse');
      return e is ServerException
          ? NetworkError(ServerFailure(e.message))
          : NetworkError(ServerFailure(e is String ? e : 'msg_something_wrong'));
    }
  }

  FutureOr close() async {
    if (_isClosed) {
      return;
    }
    _isClosed = true;
    // final ack = _answerStream
    //     .firstWhere((msg) => msg.content == #actor_terminated)
    //     .timeout(const Duration(seconds: 5),
    //         onTimeout: () => const _Message(0, #timeout));
    // (await _sendPort).send(_actorTerminate);
    // await ack;
    // _localPort.close();
    _isolate.kill(priority: Isolate.immediate);
  }
}

Future<void> _handleNetwrokRequest(dynamic message) async {
  final Logger logger = LoggerImpl();
  logger.e('Network Isolate Started, isolate:${Isolate.current.hashCode},initial message ${message.toString()}');
  final ReceivePort receivePort = ReceivePort();
  SendPort? callerPort;
  Dio? dio;

  if (message is InitIsolateMessage) {
    callerPort = message.callerPort;
    dio = Dio(
      BaseOptions(
        baseUrl: message.baseUrl,
        connectTimeout: 30000,
        receiveTimeout: 30000,
        sendTimeout: 30000,
        contentType: 'application/json;charset=utf-8',
        responseType: ResponseType.plain,
        headers: {
          'Accept': 'application/json',
          'Connection': 'keep-alive',
        },
      ),
    )..interceptors.addAll([
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          requestHeader: true,
          request: true,
        ),
      ]);
    callerPort.send(ResponseIsolateMessage.init(message.id, receivePort.sendPort));
    receivePort.cast<RequestIsolateMessage>().listen((message) async {
      late final ResponseIsolateMessage response;
      try {
        logger.e('try calling isolate:${Isolate.current.hashCode},with message:$message');
        response = await request(
          id: message.id,
          client: dio!,
          logger: logger,
          method: message.method,
          endpoint: message.endpoint,
          params: message.params,
          headers: message.headers,
          withAuth: message.withAuth,
          data: message.data,
        );
        callerPort!.send(response);
      }
      // TODO(abd): handle error message we should rerurn Error mesage gere
      catch (ex) {
        print('error in request $ex');
        callerPort!.send(ResponseIsolateMessage.error(message.id, Exception('unknown error')));
      }
    });
  }
}
