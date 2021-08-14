import 'dart:async';
import 'dart:isolate';

import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/Fimber/logger_impl.dart';
import 'package:core_sdk/utils/network_result.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project/features/backup/networking/networking_message.dart';
import 'package:graduation_project/features/backup/networking/networking_request_api.dart';

import 'networkink_ext.dart';

typedef ErrorMapper = String Function(Map<String, dynamic>);

// TODO(abd): implement wrap with base data
class NetworkIsolate {
  NetworkIsolate({required this.baseUrl, required this.logger, this.errorMapper});

  final ErrorMapper? errorMapper;
  final Logger logger;
  final String baseUrl;
  final ReceivePort _receivePort = ReceivePort();

  late final Isolate _isolate;
  late final Stream<ResponseIsolateMessage> _answerStream;
  late final SendPort _sendPort;

  bool _isClosed = false;
  int _currentId = -2 ^ 30;

  Future<void> init() async {
    final id = _currentId++;
    logger.d('Creating Network Isolate....');
    _answerStream = _receivePort.cast<ResponseIsolateMessage>().asBroadcastStream();
    _isolate = await Isolate.spawn(
      _handleNetwrokRequest,
      InitIsolateMessage(id, callerPort: _receivePort.sendPort, baseUrl: baseUrl),
    );
    _sendPort = await _waitForRemotePort();
    logger.d('Success Create Network Isolate');
    return;
  }

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
    _sendPort.send(RequestIsolateMessage(
      id,
      endpoint: endpoint,
      method: method,
      data: data,
      headers: headers,
      params: params,
      withAuth: withAuth,
    ));
    futureAnswer.then((ResponseIsolateMessage answer) {
      if (answer.isFailure) {
        // TODO(abd): provide stack trace
        completer.completeError(answer.error! /* , answer.stacktrace */);
      } else {
        completer.complete(answer.asNetworkResult(
          jsonResponse: answer.response!,
          logger: logger,
          mapper: mapper,
          errorMapper: errorMapper,
        ));
      }
    } /* , onError: (e, StackTrace stackTrace) {
      completer.completeError(const MessengerStreamBroken(), stackTrace);
    } */
        );
    return completer.future;
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

  Future<SendPort> _waitForRemotePort() => _answerStream.firstWhere((it) => it.isInit).then((it) => it.callerPort!);
}

Future<void> _handleNetwrokRequest(dynamic message) async {
  final Logger logger = LoggerImpl();
  logger.d('Network Isolate Recive Initial Message: $message, Isolate Id:${Isolate.current.hashCode}');
  final ReceivePort receivePort = ReceivePort();
  SendPort? callerPort;
  Dio? dio;

  // init isolate attributes
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
    // send init message (ready to start signal) to main isolate
    callerPort.send(ResponseIsolateMessage.init(message.id, receivePort.sendPort));
    // prepeate reciver pipeline to stream request
    receivePort.cast<RequestIsolateMessage>().listen((requestMessage) => proccessNetworkIsolatorRequests(
          requestMessage,
          logger: logger,
          dio: dio!,
          callerPort: callerPort!,
        ));
  }
}
