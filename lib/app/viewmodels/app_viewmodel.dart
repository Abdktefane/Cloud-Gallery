import 'dart:async';
import 'dart:ffi';

import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/constants.dart';
import 'package:core_sdk/utils/dialogs.dart';
import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/extensions/mobx.dart';
import 'package:core_sdk/utils/nav_stack.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/app/viewmodels/app_bar_params.dart';
import 'package:graduation_project/app/viewmodels/graduate_viewmodel.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:graduation_project/features/backup/domain/interactors/image_sync_interactor.dart';
import 'package:graduation_project/features/backup/domain/interactors/image_uploader_interactor.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:supercharged/supercharged.dart';

part 'app_viewmodel.g.dart';

const String defaultLanguage = LANGUAGE_ARABIC;

enum PageIndex {
  home,
  recommendation,
  backup,
}

@injectable
class AppViewmodel extends _AppViewmodelBase with _$AppViewmodel {
  AppViewmodel(
    Logger logger,
    PrefsRepository prefsRepository,
    ImageSaveInteractor imageSyncInteractor,
    ImageUploaderInteractor imageUploaderInteractor,
  ) : super(logger, prefsRepository, imageSyncInteractor, imageUploaderInteractor);
}

abstract class _AppViewmodelBase extends GraduateViewmodel with Store {
  _AppViewmodelBase(
    Logger logger,
    this._prefsRepository,
    this._imageSaveInteractor,
    this._imageUploaderInteractor,
  ) : super(logger);
  // imageUploadProgress = _imageUploaderObserver.asObservable();

  final PrefsRepository _prefsRepository;
  NavStack<AppBarParams?> appBarHistory = NavStack<AppBarParams?>();
  final ImageSaveInteractor _imageSaveInteractor;
  final ImageUploaderInteractor _imageUploaderInteractor;

  String? serverPath;

  //* OBSERVERS *//
  @observable
  ObservableFuture<String?>? languageFuture;

  @observable
  ObservableFuture<bool>? logoutResult;

  @observable
  AppBarParams? appBarParams = const AppBarParams(title: 'lbl_base_screen', onBackPressed: null);

  @observable
  PageIndex pageIndex = PageIndex.home;

  @observable
  InvokeStatus imageSaveStatus = const InvokeWaiting();

  @observable
  InvokeStatus imageUploadStatus = const InvokeWaiting();

  // @observable
  // ObservableStream<String>? imageUploadProgress;

  //* COMPUTED *//
  @computed
  bool get languageLoading => languageFuture.isPending;

  @computed
  String get language => languageFuture?.value ?? LANGUAGE_ARABIC;

  @computed
  bool get imageSaving => imageSaveStatus is InvokeStarted;

  @computed
  bool get imageUploading => imageUploadStatus is InvokeStarted;
  //* ACTIONS *//

  @action
  void saveImages() {
    if (!imageSaving) {
      logger.d('saveImages called in appviewmodel');
      scheduleMicrotask(() {
        getContext((context) {
          showConfirmDialog(
            context,
            context.translate('msg_confirm_save_start'),
            () => collect(
              _imageSaveInteractor(Void, timeout: const Duration(hours: 2)),
              collector: (status) {
                imageSaveStatus = status;
                if (status is InvokeSuccess) {
                  uploadImages();
                }
              },
            ),
          );
        });
      });

      logger.d('syncImages end in appviewmodel');
    }
  }

  @action
  void uploadImages() {
    if (!imageUploading) {
      logger.d('uploadImages called in appviewmodel');
      collect(
        _imageUploaderInteractor(Void, timeout: const Duration(hours: 2)),
        collector: (status) => imageUploadStatus = status,
      );
      logger.d('uploadImages end in appviewmodel');
    }
  }

  @action
  void changeLanguage(String locale, {bool refreshConstants = true}) {
    if (locale == language) {
      return;
    }
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

  @action
  void changeBaseUrl(String baseUrl) {
    _prefsRepository.setBaseUrl(baseUrl);
  }
}

String getAppBarTitle(PageIndex pageIndex) {
  switch (pageIndex) {
    case PageIndex.home:
      return 'lbl_base_screen';

    case PageIndex.recommendation:
      return 'lbl_reco';
    case PageIndex.backup:
      return 'lbl_backup';

    default:
      return 'not_exist';
  }
}
