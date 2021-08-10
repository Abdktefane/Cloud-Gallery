import 'dart:async';

import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:mobx/mobx.dart';

part 'graduate_viewmodel.g.dart';

abstract class GraduateViewmodel extends _GraduateViewmodelGraduate with _$GraduateViewmodel {
  GraduateViewmodel(Logger logger) : super(logger);
}

abstract class _GraduateViewmodelGraduate extends BaseViewmodel with Store {
  _GraduateViewmodelGraduate(Logger logger) : super(logger);

  @protected
  final List<StreamSubscription<InvokeStatus>> subscriptionList = <StreamSubscription<InvokeStatus>>[];

  void _collectStatus(InvokeStatus status) {
    switch (status.runtimeType) {
      case InvokeStarted:
        startLoading();
        break;
      case InvokeSuccess:
        stopLoading();
        break;
      case InvokeError:
        showSnack((status as InvokeError).throwable.toString());
        break;
    }
  }

  void collect(
    Stream<InvokeStatus> stream, {
    bool useLoadingCollector = false,
    void Function(InvokeStatus)? collector,
  }) {
    stream.listen(collector ?? (useLoadingCollector ? _collectStatus : (_) {})).regist(subscriptionList);
  }

  Future<void> cancelSubscription() async {
    subscriptionList.cancel();
  }

  @override
  Future<void> dispose() async {
    await cancelSubscription();
    return super.dispose();
  }
}

extension StreamSubscreptionExt on StreamSubscription<dynamic> {
  void regist(List<StreamSubscription<dynamic>> subscriptionList) => subscriptionList.add(this);
}

extension ListOfStreamSubscreptionExt on List<StreamSubscription<dynamic>> {
  Future<void> cancel() async {
    for (final StreamSubscription<dynamic> sub in this) {
      await sub.cancel();
    }
    clear();
  }
}
