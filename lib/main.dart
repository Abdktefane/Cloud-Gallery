import 'package:flutter/material.dart';
import 'package:core_sdk/utils/injectable/environments.dart';
import 'package:graduation_project/app/app.dart';
import 'app/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await inject(environment: prod.name);

  runApp(App());
}
