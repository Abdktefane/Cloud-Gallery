// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BackupViewmodel on _BackupViewmodelBase, Store {
  Computed<bool>? _$canLoadMoreBackupsComputed;

  @override
  bool get canLoadMoreBackups => (_$canLoadMoreBackupsComputed ??=
          Computed<bool>(() => super.canLoadMoreBackups, name: '_BackupViewmodelBase.canLoadMoreBackups'))
      .value;

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

  final _$imagesCountAtom = Atom(name: '_BackupViewmodelBase.imagesCount');

  @override
  ObservableStream<int>? get imagesCount {
    _$imagesCountAtom.reportRead();
    return super.imagesCount;
  }

  @override
  set imagesCount(ObservableStream<int>? value) {
    _$imagesCountAtom.reportWrite(value, super.imagesCount, () {
      super.imagesCount = value;
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

  final _$modifierAtom = Atom(name: '_BackupViewmodelBase.modifier');

  @override
  BackupModifier get modifier {
    _$modifierAtom.reportRead();
    return super.modifier;
  }

  @override
  set modifier(BackupModifier value) {
    _$modifierAtom.reportWrite(value, super.modifier, () {
      super.modifier = value;
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
  void changeModifier(BackupModifier modifier) {
    final _$actionInfo =
        _$_BackupViewmodelBaseActionController.startAction(name: '_BackupViewmodelBase.changeModifier');
    try {
      return super.changeModifier(modifier);
    } finally {
      _$_BackupViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadMore() {
    final _$actionInfo = _$_BackupViewmodelBaseActionController.startAction(name: '_BackupViewmodelBase.loadMore');
    try {
      return super.loadMore();
    } finally {
      _$_BackupViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleFilterModifer() {
    final _$actionInfo =
        _$_BackupViewmodelBaseActionController.startAction(name: '_BackupViewmodelBase.toggleFilterModifer');
    try {
      return super.toggleFilterModifer();
    } finally {
      _$_BackupViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleBackupModifire(dynamic backup) {
    final _$actionInfo =
        _$_BackupViewmodelBaseActionController.startAction(name: '_BackupViewmodelBase.toggleBackupModifire');
    try {
      return super.toggleBackupModifire(backup);
    } finally {
      _$_BackupViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
images: ${images},
imagesCount: ${imagesCount},
filter: ${filter},
modifier: ${modifier},
canLoadMoreBackups: ${canLoadMoreBackups}
    ''';
  }
}
