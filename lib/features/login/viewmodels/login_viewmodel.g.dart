// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginViewmodel on _LoginViewmodelBase, Store {
  final _$_LoginViewmodelBaseActionController =
      ActionController(name: '_LoginViewmodelBase');

  @override
  void login({required String email, required String password}) {
    final _$actionInfo = _$_LoginViewmodelBaseActionController.startAction(
        name: '_LoginViewmodelBase.login');
    try {
      return super.login(email: email, password: password);
    } finally {
      _$_LoginViewmodelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
