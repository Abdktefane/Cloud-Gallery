import 'dart:isolate';

import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/Fimber/logger_impl.dart';
import 'package:core_sdk/utils/injectable/environments.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/app/app.dart';

import 'app/di/injection_container.dart';
import 'features/backup/networking/list_base_response_model.dart';
import 'features/backup/networking/networking_isolator.dart';
import 'features/backup/networking/site_model.dart';
import 'package:get_it/get_it.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('my debug main isolate:${Isolate.current.hashCode}');

  await inject(environment: prod.name);

  final Logger logger = GetIt.I();

  final NetworkIsolate networkIsolate = NetworkIsolate(
    logger: logger,
    baseUrl: 'https://demo.fivectech.com:9001/rest/v1/',
  );

  await networkIsolate.init();
  print('first line after init');
  final res1 = await networkIsolate.request(
    method: METHOD.POST,
    endpoint: 'common/public/sites/all',
    mapper: ListBaseResponseModel.fromJson(SiteModel.fromJson),
    withAuth: false,
    // data: {'langCode': 'ar'},
  );
  print('my debug res from isolate $res1');

  final res = await networkIsolate.request(
    method: METHOD.POST,
    endpoint: 'common/public/sites/all',
    mapper: ListBaseResponseModel.fromJson(SiteModel.fromJson),
    withAuth: false,
    data: {'langCode': 'ar'},
  );

  print('my debug res from isolate2 $res');
  runApp(const App());
}
