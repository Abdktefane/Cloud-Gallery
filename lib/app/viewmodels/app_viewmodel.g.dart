// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppViewmodel on _AppViewmodelBase, Store {
  Computed<bool>? _$languageLoadingComputed;

  @override
  bool get languageLoading =>
      (_$languageLoadingComputed ??= Computed<bool>(() => super.languageLoading,
              name: '_AppViewmodelBase.languageLoading'))
          .value;
  Computed<String>? _$languageComputed;

  @override
  String get language =>
      (_$languageComputed ??= Computed<String>(() => super.language,
              name: '_AppViewmodelBase.language'))
          .value;
  Computed<bool>? _$imageSavingComputed;

  @override
  bool get imageSaving =>
      (_$imageSavingComputed ??= Computed<bool>(() => super.imageSaving,
              name: '_AppViewmodelBase.imageSaving'))
          .value;
  Computed<bool>? _$imageUploadingComputed;

  @override
  bool get imageUploading =>
      (_$imageUploadingComputed ??= Computed<bool>(() => super.imageUploading,
              name: '_AppViewmodelBase.imageUploading'))
          .value;

  final _$languageFutureAtom = Atom(name: '_AppViewmodelBase.languageFuture');

  @override
  ObservableFuture<String?>? get languageFuture {
    _$languageFutureAtom.reportRead();
    return super.languageFuture;
  }

  @override
  set languageFuture(ObservableFuture<String?>? value) {
    _$languageFutureAtom.reportWrite(value, super.languageFuture, () {
      super.languageFuture = value;
    });
  }

  final _$logoutResultAtom = Atom(name: '_AppViewmodelBase.logoutResult');

  @override
  ObservableFuture<bool>? get logoutResult {
    _$logoutResultAtom.reportRead();
    return super.logoutResult;
  }

  @override
  set logoutResult(ObservableFuture<bool>? value) {
    _$logoutResultAtom.reportWrite(value, super.logoutResult, () {
      super.logoutResult = value;
    });
  }

  final _$appBarParamsAtom = Atom(name: '_AppViewmodelBase.appBarParams');

  @override
  AppBarParams? get appBarParams {
    _$appBarParamsAtom.reportRead();
    return super.appBarParams;
  }

  @override
  set appBarParams(AppBarParams? value) {
    _$appBarParamsAtom.reportWrite(value, super.appBarParams, () {
      super.appBarParams = value;
    });
  }

  final _$pageIndexAtom = Atom(name: '_AppViewmodelBase.pageIndex');

  @override
  PageIndex get pageIndex {
    _$pageIndexAtom.reportRead();
    return super.pageIndex;
  }

  @override
  set pageIndex(PageIndex value) {
    _$pageIndexAtom.reportWrite(value, super.pageIndex, () {
      super.pageIndex = value;
    });
  }

  final _$imageSaveStatusAtom = Atom(name: '_AppViewmodelBase.imageSaveStatus');

  @override
  InvokeStatus get imageSaveStatus {
    _$imageSaveStatusAtom.reportRead();
    return super.imageSaveStatus;
  }

  @override
  set imageSaveStatus(InvokeStatus value) {
    _$imageSaveStatusAtom.reportWrite(value, super.imageSaveStatus, () {
      super.imageSaveStatus = value;
    });
  }

  final _$imageUploadStatusAtom =
      Atom(name: '_AppViewmodelBase.imageUploadStatus');

  @override
  InvokeStatus get imageUploadStatus {
    _$imageUploadStatusAtom.reportRead();
    return super.imageUploadStatus;
  }

  @override
  set imageUploadStatus(InvokeStatus value) {
    _$imageUploadStatusAtom.reportWrite(value, super.imageUploadStatus, () {
      super.imageUploadStatus = value;
    });
  }

  final _$_AppViewmodelBaseActionController =
      ActionController(name: '_AppViewmodelBase');

  @override
  void _syncImages({bool fresh = false}) {
    final _$actionInfo = _$_AppViewmodelBaseActionController.startAction(
        name: '_AppViewmodelBase._syncImages');
    try {
      return super._syncImages(fresh: fresh);
    } finally {
      _$_AppViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startImagesSync({bool fresh = false}) {
    final _$actionInfo = _$_AppViewmodelBaseActionController.startAction(
        name: '_AppViewmodelBase.startImagesSync');
    try {
      return super.startImagesSync(fresh: fresh);
    } finally {
      _$_AppViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void uploadImages() {
    final _$actionInfo = _$_AppViewmodelBaseActionController.startAction(
        name: '_AppViewmodelBase.uploadImages');
    try {
      return super.uploadImages();
    } finally {
      _$_AppViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeLanguage(String locale, {bool refreshConstants = true}) {
    final _$actionInfo = _$_AppViewmodelBaseActionController.startAction(
        name: '_AppViewmodelBase.changeLanguage');
    try {
      return super.changeLanguage(locale, refreshConstants: refreshConstants);
    } finally {
      _$_AppViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void pushRoute(AppBarParams appBarParams) {
    final _$actionInfo = _$_AppViewmodelBaseActionController.startAction(
        name: '_AppViewmodelBase.pushRoute');
    try {
      return super.pushRoute(appBarParams);
    } finally {
      _$_AppViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void popRoute(BuildContext context, {VoidCallback? onBackPressed}) {
    final _$actionInfo = _$_AppViewmodelBaseActionController.startAction(
        name: '_AppViewmodelBase.popRoute');
    try {
      return super.popRoute(context, onBackPressed: onBackPressed);
    } finally {
      _$_AppViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void replaceAppBar(AppBarParams appBarParams) {
    final _$actionInfo = _$_AppViewmodelBaseActionController.startAction(
        name: '_AppViewmodelBase.replaceAppBar');
    try {
      return super.replaceAppBar(appBarParams);
    } finally {
      _$_AppViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void navigateTo(PageIndex newPageIndex) {
    final _$actionInfo = _$_AppViewmodelBaseActionController.startAction(
        name: '_AppViewmodelBase.navigateTo');
    try {
      return super.navigateTo(newPageIndex);
    } finally {
      _$_AppViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void logout({VoidCallback? onSuccess}) {
    final _$actionInfo = _$_AppViewmodelBaseActionController.startAction(
        name: '_AppViewmodelBase.logout');
    try {
      return super.logout(onSuccess: onSuccess);
    } finally {
      _$_AppViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeBaseUrl(String baseUrl) {
    final _$actionInfo = _$_AppViewmodelBaseActionController.startAction(
        name: '_AppViewmodelBase.changeBaseUrl');
    try {
      return super.changeBaseUrl(baseUrl);
    } finally {
      _$_AppViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
languageFuture: ${languageFuture},
logoutResult: ${logoutResult},
appBarParams: ${appBarParams},
pageIndex: ${pageIndex},
imageSaveStatus: ${imageSaveStatus},
imageUploadStatus: ${imageUploadStatus},
languageLoading: ${languageLoading},
language: ${language},
imageSaving: ${imageSaving},
imageUploading: ${imageUploading}
    ''';
  }
}
