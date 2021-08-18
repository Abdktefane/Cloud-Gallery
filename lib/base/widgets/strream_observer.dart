import 'package:core_sdk/utils/extensions/list.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

// TODO(abd): move to core sdk
class StreamObserver<T> extends StatelessWidget {
  const StreamObserver({
    Key? key,
    required this.stream,
    required this.onSuccess,
    required this.onEmptyWidget,
    this.animatedDuration = const Duration(milliseconds: 500),
    this.onLoading,
    this.onClose,
    this.reverseDuration,
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
    this.transitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.layoutBuilder = AnimatedSwitcher.defaultLayoutBuilder,
  }) : super(key: key);

  final ObservableStream<T> stream;
  final Widget Function() onEmptyWidget;
  final Widget Function(T) onSuccess;
  final Widget Function()? onLoading;
  final Widget Function()? onClose;
  final Duration animatedDuration;
  final Duration? reverseDuration;
  final Curve switchInCurve;
  final Curve switchOutCurve;
  final AnimatedSwitcherTransitionBuilder transitionBuilder;
  final AnimatedSwitcherLayoutBuilder layoutBuilder;

  @override
  Widget build(BuildContext context) {
    if (stream == null) {
      return Container();
    }
    return Observer(
      builder: (_) {
        late final Widget child;
        switch (stream.status) {
          case StreamStatus.waiting:
            print('on waitin');

            child = onLoading?.call() ?? const Center(child: CircularProgressIndicator());
            break;
          case StreamStatus.active:
            print('on active');
            child = onSuccessHandler(stream.value);
            break;
          case StreamStatus.done:
            print('on done');
            child = onClose?.call() ?? const SizedBox();
            break;
        }
        return AnimatedSwitcher(
          layoutBuilder: layoutBuilder,
          switchInCurve: switchInCurve,
          transitionBuilder: transitionBuilder,
          switchOutCurve: switchInCurve,
          reverseDuration: reverseDuration,
          duration: animatedDuration,
          child: child,
        );
      },
    );
  }

  Widget onSuccessHandler(T? value) {
    print('onSuccess handler $T,${T.runtimeType},condation: ${T is List}');
    if (value == null) {
      return onEmptyWidget();
    }

    if ((value is List) && value.isNullOrEmpty) {
      return onEmptyWidget();
    }

    return onSuccess(value);
  }
}
