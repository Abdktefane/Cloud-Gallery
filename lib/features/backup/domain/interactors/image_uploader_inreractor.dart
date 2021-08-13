import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:actors/actors.dart';
import 'package:async_task/async_task.dart';
import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:core_sdk/error/exceptions.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/Fimber/logger_impl.dart';
import 'package:core_sdk/utils/constants.dart';
import 'package:core_sdk/utils/network_result.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';

class AnyFuckinClass {
  const AnyFuckinClass({required this.afsadsf});
  final int afsadsf;
}

class ImageUploader with Handler<int, bool> {
  // const ImageUploader(this.attr);
  // final AnyFuckinClass attr;

  // const ImageUploader(this._backupsRepository);

  // final BackupsRepository _backupsRepository;

  ImageUploader(String url) {
    _dio = Dio();
  }

  late final Dio _dio;

  @override
  FutureOr<bool> handle(int message) async {
    print(
        'my debug called image uploader handle,isolate:${Isolate.current.hashCode},message:$message,attr:$_dio,attr2:url');
    return true;
  }
}

class ImageUploader2 extends AsyncTask<String, bool> {
  ImageUploader2(this.url) {
    dio = Dio(BaseOptions(
      baseUrl: url,
      connectTimeout: 3000,
      receiveTimeout: 3000,
      sendTimeout: 3000,
      contentType: 'application/json;charset=utf-8',
      responseType: ResponseType.plain,
      headers: {'Accept': 'application/json', 'Connection': 'keep-alive'},
    ));
  }

  late final Dio dio;

  final String url;

  @override
  AsyncTask<String, bool> instantiate(String parameters, [Map<String, SharedData>? sharedData]) {
    return ImageUploader2(parameters);
  }

  @override
  String parameters() {
    return url;
  }

  @override
  FutureOr<bool> run() {
    print('${dio.options} ,isolate:${Isolate.current.hashCode}');
    return Future.value(true);
  }
}

Future<Map<String, dynamic>> decodeJson(Response response) {
  final jsonResponse = jsonDecode(response.data);
  print('my debug res is $jsonResponse');
  return jsonResponse;
}
