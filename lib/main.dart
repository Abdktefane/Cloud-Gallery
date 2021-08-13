import 'dart:isolate';

import 'package:actors/actors.dart';
import 'package:async_task/async_task.dart';
import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:core_sdk/utils/Fimber/logger_impl.dart';
import 'package:flutter/material.dart';
import 'package:core_sdk/utils/injectable/environments.dart';
import 'package:graduation_project/app/app.dart';
import 'package:graduation_project/features/backup/domain/interactors/image_uploader_inreractor.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'app/di/injection_container.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'features/backup/networking/list_base_response_model.dart';
import 'features/backup/networking/networking_isolator.dart';
import 'features/backup/networking/site_model.dart';

List<AsyncTask> _taskTypeRegister() => [ImageUploader2('test')];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('my debug main isolate:${Isolate.current.hashCode}');

  await inject(environment: prod.name);

  final NetworkIsolate networkIsolate = NetworkIsolate(
    logger: LoggerImpl(),
    baseUrl: 'https://demo.fivectech.com:9001/rest/v1/',
  );

  await networkIsolate.init();
  await networkIsolate.request(
    method: METHOD.POST,
    endpoint: 'common/public/sites/all',
    mapper: ListBaseResponseModel.fromJson(SiteModel.fromJson),
    withAuth: false,
    data: {'langCode': 'ar'},
  );

  final res = await networkIsolate.request(
    method: METHOD.POST,
    endpoint: 'common/public/sites/all',
    mapper: ListBaseResponseModel.fromJson(SiteModel.fromJson),
    withAuth: false,
    data: {'langCode': 'ar'},
  );

  print('my debug res from isolate $res');
  runApp(const App());
}
