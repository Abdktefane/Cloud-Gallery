import 'dart:async';
import 'dart:isolate';

import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

// TODO(abd): move to core sdk

abstract class BaseIsolate<I extends BaseIsolateMessage, O extends BaseInitResponseIsolateMessage> {
  BaseIsolate(this.logger);

  @protected
  final Logger logger;
  @protected
  final ReceivePort receivePort = ReceivePort();

  @protected
  late final Stream<O> answerStream;
  @protected
  late final SendPort sendPort;
  @protected
  late final Isolate isolate;

  @protected
  bool isClosed = false;
  @protected
  int currentId = -2 ^ 30;

  Future<void> init() async {
    final id = currentId++;
    logger.d('Creating Network Isolate....');
    answerStream = receivePort.cast<O>().asBroadcastStream();
    isolate = await spawnIsolate(id);
    sendPort = await _waitForRemotePort();
    logger.d('Success Create Network Isolate');
    return;
  }

  Future<SendPort> _waitForRemotePort() => answerStream.firstWhere((it) => it.isInit).then((it) => it.callerPort!);

  Future<O> proccess(I Function(int id) inputBuilder) {
    final id = currentId++;
    final futureAnswer = answerStream.firstWhere((it) => it.id == id);
    sendPort.send(inputBuilder(id));
    return futureAnswer;
  }

  Future<Isolate> spawnIsolate(int id);

  FutureOr close() async {
    if (isClosed) {
      return;
    }
    isClosed = true;
    // final ack = _answerStream
    //     .firstWhere((msg) => msg.content == #actor_terminated)
    //     .timeout(const Duration(seconds: 5),
    //         onTimeout: () => const _Message(0, #timeout));
    // (await _sendPort).send(_actorTerminate);
    // await ack;
    // _localPort.close();
    // isolate.kill(priority: Isolate.immediate);
    isolate.kill();
  }
}

abstract class BaseIsolateMessage extends Equatable {
  const BaseIsolateMessage(this.id);
  final int id;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [id];
}

abstract class BaseInitResponseIsolateMessage extends BaseIsolateMessage with EquatableMixin {
  const BaseInitResponseIsolateMessage(int id, {this.callerPort, this.error, this.st}) : super(id);
  final SendPort? callerPort;
  final Exception? error;
  final StackTrace? st;
  @override
  bool? get stringify => true;

  bool get isInit => callerPort != null;
  bool get isFailure => error != null;

  @override
  List<Object?> get props => [id, callerPort, error, st];
}
