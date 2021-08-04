// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RegisterViewmodel on _RegisterViewmodelBase, Store {
  final _$_RegisterViewmodelBaseActionController =
      ActionController(name: '_RegisterViewmodelBase');

  @override
  void register({required String email, required String password}) {
    final _$actionInfo = _$_RegisterViewmodelBaseActionController.startAction(
        name: '_RegisterViewmodelBase.register');
    try {
      return super.register(email: email, password: password);
    } finally {
      _$_RegisterViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
