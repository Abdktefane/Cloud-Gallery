import 'package:flutter/material.dart';
import 'package:graduation_project/base/widgets/graduate_empty_widget.dart';
import 'package:graduation_project/base/widgets/graduate_loader.dart';
import 'package:graduation_project/base/widgets/strream_observer.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class GraduateStreamObserver<T> extends StatelessWidget {
  const GraduateStreamObserver({
    Key? key,
    required this.stream,
    required this.onSuccess,
    this.animatedDuration = const Duration(milliseconds: 500),
    this.onLoading,
    this.onClose,
    this.reverseDuration,
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
    this.transitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.layoutBuilder = AnimatedSwitcher.defaultLayoutBuilder,
    this.useAnimatedSwitcher = true,
  }) : super(key: key);

  final ObservableStream<T> stream;
  final Widget Function(T) onSuccess;
  final Widget Function()? onLoading;
  final Widget Function()? onClose;
  final Duration animatedDuration;
  final Duration? reverseDuration;
  final Curve switchInCurve;
  final Curve switchOutCurve;
  final AnimatedSwitcherTransitionBuilder transitionBuilder;
  final AnimatedSwitcherLayoutBuilder layoutBuilder;
  final bool useAnimatedSwitcher;

  @override
  Widget build(BuildContext context) {
    return StreamObserver(
      onEmptyWidget: () => const Center(child: GraduateEmptyWidget()),
      onLoading: onLoading ?? () => const Center(child: GraduateLoader()),
      stream: stream,
      onSuccess: onSuccess,
      animatedDuration: animatedDuration,
      layoutBuilder: layoutBuilder,
      onClose: onClose,
      reverseDuration: reverseDuration,
      switchOutCurve: switchOutCurve,
      switchInCurve: switchInCurve,
      transitionBuilder: transitionBuilder,
      useAnimatedSwitcher: useAnimatedSwitcher,
    );
  }
}
