import 'dart:isolate';

import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:core_sdk/utils/injectable/environments.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graduation_project/app/app.dart';

import 'app/di/injection_container.dart';
import 'features/backup/networking/list_base_response_model.dart';
import 'features/backup/networking/networking_isolator.dart';
import 'features/backup/networking/site_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('my debug main isolate:${Isolate.current.hashCode}');

  await inject(environment: prod.name);

  final NetworkIsolate networkIsolate = GetIt.I();

  // await networkIsolate.request(
  //   method: METHOD.POST,
  //   endpoint: 'common/public/sites/all',
  //   mapper: ListBaseResponseModel.fromJson(SiteModel.fromJson),
  //   withAuth: false,
  //   data: {'langCode': 'ar'},
  // );

  runApp(const App());
}
