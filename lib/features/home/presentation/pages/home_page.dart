import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/extensions/mobx.dart';
import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/features/home/presentation/viewmodels/home_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  static MaterialPageRoute get pageRoute => MaterialPageRoute(builder: (context) => const HomePage());

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends MobxState<HomePage, HomeViewmodel> {
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
    return Container(color: RED);
  }
}
