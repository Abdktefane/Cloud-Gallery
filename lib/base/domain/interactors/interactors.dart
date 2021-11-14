import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/features/backup/data/stores/backup_store.dart';
import 'package:mobx/mobx.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

abstract class InvokeStatus extends Equatable {
  const InvokeStatus();
}

class InvokeWaiting extends InvokeStatus {
  const InvokeWaiting();
  @override
  List<Object> get props => [];
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
  Stream<InvokeStatus> call(P params, {Duration timeout = defaultTimeout}) async* {
    try {
      yield const InvokeStarted();

      await doWork(params).timeout(timeout, onTimeout: () => throw TimeoutException(''));

      yield const InvokeSuccess();
    } catch (error) {
      yield InvokeError(error);
    }
  }

  @protected
  Future<void> doWork(P params);

  Future<void> executeSync(P params) async => doWork(params);

  static const Duration defaultTimeout = Duration(minutes: 5);

  // Stream<InvokeStatus> doOnSuccess(
  //   P params, {
  //   required AsyncCallback onSuccss,
  //   Duration timeout = defaultTimeout,
  // }) =>
  //     call(params, timeout: timeout).asyncMap((status) async {
  //       if (status is InvokeSuccess) {
  //         await onSuccss();
  //       }
  //       return status;
  //     });

  // Stream<InvokeStatus> then<T>(
  //   P params, {
  //   required Interactor<T> interactor,
  //   required T interactorParams,
  //   Duration timeout = defaultTimeout,
  // }) =>
  //     call(params, timeout: timeout).switchMap((status) {
  //       if (status is InvokeSuccess) {
  //         return interactor.call(interactorParams);
  //       }
  //       return Stream.fromIterable([status]);
  //     });
}

extension InteractorStreamExt on Stream<InvokeStatus> {
  Stream<InvokeStatus> doOnSuccess(AsyncCallback onSuccss) => asyncMap((status) async {
        if (status is InvokeSuccess) {
          await onSuccss();
        }
        return status;
      });

  Stream<InvokeStatus> then<T>({
    required Interactor<T> interactor,
    required T params,
    Duration timeout = const Duration(minutes: 5),
  }) =>
      switchMap((status) {
        if (status is InvokeSuccess) {
          return interactor.call(params, timeout: timeout);
        }
        return Stream.fromIterable([status]);
      });
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

  bool get hasListener => _controller.hasListener;

  void call(P params) => _controller.add(params);

  Stream<T> createObservable(P params);

  ValueStream<T>? outputStream;

  ValueStream<T> observe() {
    outputStream = _controller.switchMap(
      (P value) => createObservable(value)
          .where((event) => event != null)
          .doOnError((ex, st) => print('SubjectInteractor error ex:$ex, st: $st'))
          .distinct((oldValues, newValues) {
        if (T is List) {
          return eq(oldValues, newValues);
        } else {
          return oldValues == newValues;
        }
      }),
    ) as ValueStream<T>;

    return outputStream!;
  }

  P? get valueOrNull => _controller.valueOrNull;

  // ignore: todo
  Future<void> dispose() => _controller.close();
}

extension SubjectInteractorExt<P, T> on SubjectInteractor<P, T> {
  ObservableStream<T> asObservable() => observe().asObservable();
}
