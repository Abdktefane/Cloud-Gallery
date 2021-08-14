import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'dart:async';
import 'dart:isolate';
import 'package:equatable/equatable.dart';

import 'package:flutter/foundation.dart';

abstract class BaseIsolateMessage extends Equatable {
  const BaseIsolateMessage(this.id);
  final int id;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [id];
}

abstract class BaseInitResponseIsolateMessage extends BaseIsolateMessage with EquatableMixin {
  const BaseInitResponseIsolateMessage(int id, {this.callerPort, this.error}) : super(id);
  final SendPort? callerPort;
  final Exception? error;
  @override
  bool? get stringify => true;

  bool get isInit => callerPort != null;
  bool get isError => error != null;

  @override
  List<Object?> get props => [id, callerPort];
}

abstract class BaseIsolate<I extends BaseIsolateMessage, O extends BaseInitResponseIsolateMessage> {
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

  Future<Isolate> spawnIsolate(int id);
}
