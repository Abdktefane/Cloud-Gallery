import 'package:core_sdk/utils/injectable/environments.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:graduation_project/app/app.dart';

import 'app/di/injection_container.dart';

const bool kShowRec = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await inject(environment: prod.name);

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: kDebugMode);

  runApp(const App());
}
