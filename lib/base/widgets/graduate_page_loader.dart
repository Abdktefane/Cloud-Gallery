import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';
import 'package:core_sdk/utils/mobx/widgets/mobx_loading_page.dart';
import 'package:core_sdk/utils/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/base/widgets/graduate_empty_widget.dart';
import 'package:graduation_project/base/widgets/graduate_loader.dart';

class GraduatePageLoader extends StatelessWidget {
  const GraduatePageLoader({
    Key? key,
    this.isLoading = true,
    this.animationDuration = const Duration(milliseconds: 400),
    this.barrierColor = const Color(0xFFc7c7c7),
    required this.child,
  }) : super(key: key);

  final bool isLoading;
  final Duration animationDuration;
  final Color barrierColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LoadingPage(
      isLoading: isLoading,
      loadingWidget: const Center(child: GraduateLoader()),
      animationDuration: animationDuration,
      barrierColor: barrierColor,
      child: child,
    );
  }
}

class GraduateMobxPageLoader<T extends BaseViewmodel> extends StatelessWidget {
  const GraduateMobxPageLoader({
    Key? key,
    this.animationDuration = const Duration(milliseconds: 400),
    this.barrierColor = const Color(0xFFc7c7c7),
    required this.viewmodel,
    required this.child,
  }) : super(key: key);

  final Duration animationDuration;
  final Color barrierColor;
  final Widget child;
  final T viewmodel;

  @override
  Widget build(BuildContext context) {
    return MobxLoadingPage(
      viewmodel: viewmodel,
      animationDuration: animationDuration,
      barrierColor: barrierColor,
      loadingWidget: const Center(child: GraduateLoader()),
      child: child,
    );
  }
}
