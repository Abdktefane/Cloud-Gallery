import 'package:core_sdk/utils/constants.dart';
import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/extensions/mobx.dart';
import 'package:core_sdk/utils/nav_stack.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/app/viewmodels/app_bar_params.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:core_sdk/utils/extensions/string.dart';
import 'package:supercharged/supercharged.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';

part 'app_viewmodel.g.dart';

const String defaultLanguage = LANGUAGE_ARABIC;

enum PageIndex {
  home,
  recommendation,
  backup,
}

@injectable
class AppViewmodel extends _AppViewmodelBase with _$AppViewmodel {
  AppViewmodel(Logger logger, PrefsRepository prefsRepository) : super(logger, prefsRepository);
}

abstract class _AppViewmodelBase extends BaseViewmodel with Store {
  _AppViewmodelBase(Logger logger, this._prefsRepository) : super(logger);

  PrefsRepository _prefsRepository;
  NavStack<AppBarParams?> appBarHistory = NavStack<AppBarParams?>();

  //* OBSERVERS *//
  @observable
  ObservableFuture<String?>? languageFuture;

  @observable
  ObservableFuture<bool>? logoutResult;

  @observable
  AppBarParams? appBarParams = const AppBarParams(title: 'lbl_home', onBackPressed: null);

  @observable
  PageIndex pageIndex = PageIndex.home;

  //* COMPUTED *//
  @computed
  bool get languageLoading => languageFuture.isPending;

  @computed
  String get language => languageFuture?.value ?? LANGUAGE_ARABIC;

  //* ACTIONS *//

  @action
  void changeLanguage(String locale, {bool refreshConstants = true}) {
    if (locale == language) return;
    if (!refreshConstants) {
      languageFuture = ObservableFuture(_prefsRepository.setApplicationLanguage(locale).then((_) {
        return locale;
      }));
    } else {
      languageFuture = ObservableFuture(
        _prefsRepository.setApplicationLanguage(locale).then((contstants) {
          return locale;
        }).catchError((_) {
          _prefsRepository.setApplicationLanguage(locale == LANGUAGE_ARABIC ? LANGUAGE_ENGLISH : LANGUAGE_ARABIC);
        }),
      );
    }
  }

  @action
  void pushRoute(AppBarParams appBarParams) {
    appBarHistory.push(this.appBarParams);
    this.appBarParams = appBarParams;
  }

  @action
  void popRoute(BuildContext context, {VoidCallback? onBackPressed}) {
    appBarParams = appBarHistory.pop();
    onBackPressed == null ? context.pop() : onBackPressed();
  }

  @action
  void replaceAppBar(AppBarParams appBarParams) {
    this.appBarParams = appBarParams;
  }

  @action
  void navigateTo(PageIndex newPageIndex) {
    if (pageIndex != newPageIndex) {
      pageIndex = newPageIndex;
      appBarHistory.clear();
      pushRoute(AppBarParams(title: getAppBarTitle(pageIndex), onBackPressed: null));
    }
  }

  @action
  void logout({VoidCallback? onSuccess}) {
    logoutResult = futureWrapper(
      () => _prefsRepository.clearUserData().then((_) {
        onSuccess?.call();
        return true;
      }),
      catchBlock: (err) => showSnack(err ?? '', duration: 2.seconds),
    );
  }
}

String getAppBarTitle(PageIndex pageIndex) {
  switch (pageIndex) {
    case PageIndex.home:
      return 'lbl_home';

    case PageIndex.recommendation:
      return 'lbl_reco';
    case PageIndex.backup:
      return 'lbl_backup';

    default:
      return 'not_exist';
  }
}
