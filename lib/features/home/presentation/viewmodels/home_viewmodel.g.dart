// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeViewmodel on _HomeViewmodelBase, Store {
  Computed<bool>? _$textModeComputed;

  @override
  bool get textMode =>
      (_$textModeComputed ??= Computed<bool>(() => super.textMode,
              name: '_HomeViewmodelBase.textMode'))
          .value;
  Computed<bool>? _$imageModeComputed;

  @override
  bool get imageMode =>
      (_$imageModeComputed ??= Computed<bool>(() => super.imageMode,
              name: '_HomeViewmodelBase.imageMode'))
          .value;
  Computed<bool>? _$simModeComputed;

  @override
  bool get simMode => (_$simModeComputed ??= Computed<bool>(() => super.simMode,
          name: '_HomeViewmodelBase.simMode'))
      .value;
  Computed<bool>? _$recommendationsModeComputed;

  @override
  bool get recommendationsMode => (_$recommendationsModeComputed ??=
          Computed<bool>(() => super.recommendationsMode,
              name: '_HomeViewmodelBase.recommendationsMode'))
      .value;
  Computed<ValueKey<dynamic>>? _$listKeyComputed;

  @override
  ValueKey<dynamic> get listKey =>
      (_$listKeyComputed ??= Computed<ValueKey<dynamic>>(() => super.listKey,
              name: '_HomeViewmodelBase.listKey'))
          .value;

  final _$queryAtom = Atom(name: '_HomeViewmodelBase.query');

  @override
  String? get query {
    _$queryAtom.reportRead();
    return super.query;
  }

  @override
  set query(String? value) {
    _$queryAtom.reportWrite(value, super.query, () {
      super.query = value;
    });
  }

  final _$pathAtom = Atom(name: '_HomeViewmodelBase.path');

  @override
  String? get path {
    _$pathAtom.reportRead();
    return super.path;
  }

  @override
  set path(String? value) {
    _$pathAtom.reportWrite(value, super.path, () {
      super.path = value;
    });
  }

  final _$serverPathAtom = Atom(name: '_HomeViewmodelBase.serverPath');

  @override
  String? get serverPath {
    _$serverPathAtom.reportRead();
    return super.serverPath;
  }

  @override
  set serverPath(String? value) {
    _$serverPathAtom.reportWrite(value, super.serverPath, () {
      super.serverPath = value;
    });
  }

  final _$imageSourceAtom = Atom(name: '_HomeViewmodelBase.imageSource');

  @override
  BackupModifier get imageSource {
    _$imageSourceAtom.reportRead();
    return super.imageSource;
  }

  @override
  set imageSource(BackupModifier value) {
    _$imageSourceAtom.reportWrite(value, super.imageSource, () {
      super.imageSource = value;
    });
  }

  final _$searchResultAtom = Atom(name: '_HomeViewmodelBase.searchResult');

  @override
  ObservableStream<PaginationResponse<SearchResultModel>>? get searchResult {
    _$searchResultAtom.reportRead();
    return super.searchResult;
  }

  @override
  set searchResult(
      ObservableStream<PaginationResponse<SearchResultModel>>? value) {
    _$searchResultAtom.reportWrite(value, super.searchResult, () {
      super.searchResult = value;
    });
  }

  final _$searchByImageAsyncAction =
      AsyncAction('_HomeViewmodelBase.searchByImage');

  @override
  Future<void> searchByImage(int index) {
    return _$searchByImageAsyncAction.run(() => super.searchByImage(index));
  }

  final _$_HomeViewmodelBaseActionController =
      ActionController(name: '_HomeViewmodelBase');

  @override
  void toggleImageSource() {
    final _$actionInfo = _$_HomeViewmodelBaseActionController.startAction(
        name: '_HomeViewmodelBase.toggleImageSource');
    try {
      return super.toggleImageSource();
    } finally {
      _$_HomeViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getRecommendations() {
    final _$actionInfo = _$_HomeViewmodelBaseActionController.startAction(
        name: '_HomeViewmodelBase.getRecommendations');
    try {
      return super.getRecommendations();
    } finally {
      _$_HomeViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void searchByText(String query) {
    final _$actionInfo = _$_HomeViewmodelBaseActionController.startAction(
        name: '_HomeViewmodelBase.searchByText');
    try {
      return super.searchByText(query);
    } finally {
      _$_HomeViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void searchBySimiliraty(String serverPath) {
    final _$actionInfo = _$_HomeViewmodelBaseActionController.startAction(
        name: '_HomeViewmodelBase.searchBySimiliraty');
    try {
      return super.searchBySimiliraty(serverPath);
    } finally {
      _$_HomeViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void search({dynamic fresh = false}) {
    final _$actionInfo = _$_HomeViewmodelBaseActionController.startAction(
        name: '_HomeViewmodelBase.search');
    try {
      return super.search(fresh: fresh);
    } finally {
      _$_HomeViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSearch({bool text = false, bool image = false, bool sim = false}) {
    final _$actionInfo = _$_HomeViewmodelBaseActionController.startAction(
        name: '_HomeViewmodelBase.clearSearch');
    try {
      return super.clearSearch(text: text, image: image, sim: sim);
    } finally {
      _$_HomeViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
query: ${query},
path: ${path},
serverPath: ${serverPath},
imageSource: ${imageSource},
searchResult: ${searchResult},
textMode: ${textMode},
imageMode: ${imageMode},
simMode: ${simMode},
recommendationsMode: ${recommendationsMode},
listKey: ${listKey}
    ''';
  }
}
