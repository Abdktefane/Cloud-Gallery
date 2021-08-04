import 'package:core_sdk/utils/app_localizations.dart';
import 'package:core_sdk/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:graduation_project/features/splash/ui/pages/splash_page.dart';
import 'package:provider/provider.dart';

import 'package:graduation_project/app/routes/router.dart';
import 'package:graduation_project/app/theme/graduate_light_theme.dart';
import 'package:graduation_project/app/viewmodels/app_viewmodel.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  static final GlobalKey<NavigatorState> navKey = GlobalKey(debugLabel: 'Main_Graduation_Navigator');
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final PrefsRepository? prefs = GetIt.I();
  final AppViewmodel appViewModel = GetIt.I<AppViewmodel>();

  // final FirebaseMessaging _firebaseMessaging = GetIt.I();

  @override
  void initState() {
    super.initState();
    if (prefs!.languageCode == null) {
      prefs!.setApplicationLanguage(LANGUAGE_ARABIC);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => appViewModel,
      child: Observer(builder: (_) {
        return MaterialApp(
          navigatorKey: App.navKey,
          locale: Locale(appViewModel.language),
          initialRoute: SplashPage.route,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: PageRouter.route,
          supportedLocales: const [
            Locale(LANGUAGE_ENGLISH),
            Locale(LANGUAGE_ARABIC),
          ],
          theme: lightTheme(isArabic: appViewModel.language == LANGUAGE_ARABIC),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
            for (final supportedLocale in supportedLocales) {
              if (locale != null && supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
        );
      }),
    );
  }
}
