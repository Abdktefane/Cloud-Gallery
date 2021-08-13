// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BackupViewmodel on _BackupViewmodelBase, Store {
  final _$imagesAtom = Atom(name: '_BackupViewmodelBase.images');

  @override
  ObservableStream<List<Backup>?>? get images {
    _$imagesAtom.reportRead();
    return super.images;
  }

  @override
  set images(ObservableStream<List<Backup>?>? value) {
    _$imagesAtom.reportWrite(value, super.images, () {
      super.images = value;
    });
  }

  final _$filterAtom = Atom(name: '_BackupViewmodelBase.filter');

  @override
  BackupStatus get filter {
    _$filterAtom.reportRead();
    return super.filter;
  }

  @override
  set filter(BackupStatus value) {
    _$filterAtom.reportWrite(value, super.filter, () {
      super.filter = value;
    });
  }

  final _$_BackupViewmodelBaseActionController = ActionController(name: '_BackupViewmodelBase');

  @override
  void changeFilter(BackupStatus filter) {
    final _$actionInfo = _$_BackupViewmodelBaseActionController.startAction(name: '_BackupViewmodelBase.changeFilter');
    try {
      return super.changeFilter(filter);
    } finally {
      _$_BackupViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
images: ${images},
filter: ${filter}
    ''';
  }
}
