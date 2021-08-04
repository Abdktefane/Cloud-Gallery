import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:flutter/material.dart';

String? passwordValidator({required String password, BuildContext? context}) {
  if (password.isEmpty) {
    return context!.translate('msg_password_empty');
  } else if (password.length < 6) {
    return context!.translate('msg_short_password');
  }
  return null;
}

String? emailValidator({required String? email, BuildContext? context}) {
  const Pattern pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z](?:[a-zA-Z]"
      r'{0,253}[a-zA-Z])?(?:\.[a-zA-Z0-9](?:[a-zA-Z]'
      r'{0,253}[a-zA-Z0-9])?)*$';
  final RegExp regex = RegExp(pattern as String);

  if (email == null || !regex.hasMatch(email))
    return context!.translate('msg_invalid_mail');
  else
    return null;
}

String? confirmPasswordValidator({required String password, BuildContext? context, String? confirmPassword}) {
  if (password.isEmpty) {
    return context!.translate('msg_password_empty');
  } else if (password.length < 3) {
    return context!.translate('msg_short_password');
  } else if (password != confirmPassword) {
    return context!.translate('msg_password_match');
  }
  return null;
}
