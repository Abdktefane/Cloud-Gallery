import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/features/splash/viewmodels/splash_viewmodel.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);

  static const String route = '/';

  static MaterialPageRoute get pageRoute => MaterialPageRoute(builder: (context) => const SplashPage());

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends MobxState<SplashPage, SplashViewmodel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
