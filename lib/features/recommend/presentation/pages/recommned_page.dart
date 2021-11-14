import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/extensions/mobx.dart';
import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/features/recommend/presentation/viewmodels/recommend_viewmodel.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({
    Key? key,
  }) : super(key: key);

  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  static MaterialPageRoute get pageRoute => MaterialPageRoute(builder: (context) => const RecommendPage());

  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends MobxState<RecommendPage, RecommendViewmodel> {
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
    return Container(color: GREEN);
  }
}
