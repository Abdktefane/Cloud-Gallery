// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeViewmodel on _HomeViewmodelBase, Store {
  final _$imageSourceAtom = Atom(name: '_HomeViewmodelBase.imageSource');

  @override
  ImageSourceType get imageSource {
    _$imageSourceAtom.reportRead();
    return super.imageSource;
  }

  @override
  set imageSource(ImageSourceType value) {
    _$imageSourceAtom.reportWrite(value, super.imageSource, () {
      super.imageSource = value;
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
  String toString() {
    return '''
imageSource: ${imageSource}
    ''';
  }
}
