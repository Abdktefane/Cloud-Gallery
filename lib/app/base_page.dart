import 'dart:async';

import 'package:animations/animations.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/extensions/mobx.dart';
import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/app/viewmodels/app_viewmodel.dart';
import 'package:graduation_project/base/ext/widget_ext.dart';
import 'package:graduation_project/base/widgets/graduate_app_bar.dart';
import 'package:graduation_project/base/widgets/graduate_bottom_nav.dart';
import 'package:graduation_project/features/backup/data/stores/backup_store.dart';
import 'package:graduation_project/features/backup/presentation/pages/backup_page.dart';
import 'package:graduation_project/features/home/presentation/pages/home_page.dart';
import 'package:graduation_project/features/recommend/presentation/pages/recommned_page.dart';
import 'package:graduation_project/main.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';
import 'package:get_it/get_it.dart';

class BasePage extends StatefulWidget {
  const BasePage({
    Key? key,
  }) : super(key: key);

  static const String route = '/base';

  static CupertinoPageRoute get pageRoute => CupertinoPageRoute(builder: (context) => const BasePage());

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends ProviderMobxState<BasePage, AppViewmodel> {
  AppViewmodel? appViewmodel;
  final BackupsStore _backupsStore = GetIt.I();

  final List<Widget> pages = <Widget>[
    Navigator(key: HomePage.navKey, onGenerateRoute: (RouteSettings route) => HomePage.pageRoute),
    if (kShowRec)
      Navigator(key: RecommendPage.navKey, onGenerateRoute: (RouteSettings route) => RecommendPage.pageRoute),
    Navigator(key: BackupPage.navKey, onGenerateRoute: (RouteSettings route) => BackupPage.pageRoute),
  ];

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() {
      appViewmodel?.startImagesSync();
    });
    // scheduleMicrotask(() {
    //   appViewmodel = Provider.of<AppViewmodel>(context, listen: false);
    //   appViewmodel?.saveImages();
    // });
  }

  @override
  void didChangeDependencies() {
    appViewmodel = Provider.of<AppViewmodel>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: GraduateAppBar(appViewModel: appViewmodel),
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            buildBaseScreenBody,
            Positioned(
              width: context.fullWidth * 0.6,
              height: 60.0 + context.mediaQuery.padding.bottom,
              bottom: 12.0,
              child: GraduateBottomNavigationBar(appViewModel: appViewmodel),
            ),
          ],
        ),
      ),
    );
  }

  Widget get buildBaseScreenBody => Observer(
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              Expanded(
                child: PageTransitionSwitcher(
                  duration: 400.milliseconds,
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                  ) =>
                      FadeThroughTransition(
                    secondaryAnimation: secondaryAnimation,
                    animation: animation,
                    child: child,
                  ),
                  child: pages[appViewmodel!.pageIndex.index],
                ),
              ),
            ],
          );
        },
      );

  Future<bool> onWillPop() async {
    if (appViewmodel!.pageIndex == PageIndex.home) {
      bool exitConfirmed = false;
      await showConfirmDialog(
        context,
        context.translate('msg_app_exit_confirm'),
        () => exitConfirmed = true,
      );
      return exitConfirmed;
    } else {
      appViewmodel!.navigateTo(PageIndex.home);
      return Future<bool>.value(false);
    }
  }
}
