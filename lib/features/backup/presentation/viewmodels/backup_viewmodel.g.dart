// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BackupViewmodel on _BackupViewmodelBase, Store {
  final _$imagesAtom = Atom(name: '_BackupViewmodelBase.images');

  @override
  ObservableStream<List<Backup>>? get images {
    _$imagesAtom.reportRead();
    return super.images;
  }

  @override
  set images(ObservableStream<List<Backup>>? value) {
    _$imagesAtom.reportWrite(value, super.images, () {
      super.images = value;
    });
  }

  @override
  String toString() {
    return '''
images: ${images}
    ''';
  }
}
