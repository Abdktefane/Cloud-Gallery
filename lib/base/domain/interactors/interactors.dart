import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:mobx/mobx.dart';
import 'package:collection/collection.dart';

abstract class InvokeStatus extends Equatable {
  const InvokeStatus();
}

class InvokeStarted extends InvokeStatus {
  const InvokeStarted();
  @override
  List<Object> get props => [];
}

class InvokeSuccess extends InvokeStatus {
  const InvokeSuccess();
  @override
  List<Object> get props => [];
}

class InvokeError extends InvokeStatus {
  const InvokeError(this.throwable);
  final dynamic throwable;
  @override
  List<Object> get props => [throwable.toString()];
}

abstract class Interactor<P> {
  const Interactor();

  Stream<InvokeStatus> call(
    P params, {
    Duration timeout = defaultTimeout,
  }) async* {
    try {
      yield const InvokeStarted();
      await doWork(params).timeout(
        timeout,
        onTimeout: () => throw TimeoutException(''),
      );
      yield const InvokeSuccess();
    } catch (error) {
      yield InvokeError(error);
    }
  }

  @protected
  Future<void> doWork(P params);

  Future<void> executeSync(P params) async => doWork(params);

  static const Duration defaultTimeout = Duration(minutes: 5);
}

abstract class ResultInteractor<P, R> {
  Stream<R> call(P params) async* {
    yield await doWork(params);
  }

  @protected
  Future<R> doWork(P params);
}

abstract class SubjectInteractor<P, T> {
  final BehaviorSubject<P> _controller = BehaviorSubject<P>();

  void call(P params) => _controller.add(params);

  Stream<T> createObservable(P params);

  ValueStream<T> observe() => _controller.switchMap(
        (P value) => createObservable(value).where((event) => event != null),
      ) as ValueStream<T>;

  // ignore: todo
  Future<void> dispose() => _controller.close();
}

extension SubjectInteractorExt<P, T> on SubjectInteractor<P, T> {
  ObservableStream<T> asObservable() => observe().asObservable();
}
