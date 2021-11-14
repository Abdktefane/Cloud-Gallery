import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:injectable/injectable.dart';
import 'package:moor/ffi.dart';
import 'package:moor/isolate.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

void _startBackground(_IsolateStartRequest request) {
  // this is the entry point from the background isolate! Let's create
  // the database from the path we received
  final executor = VmDatabase(File(request.targetPath), logStatements: request.isDebugMode);
  // we're using MoorIsolate.inCurrent here as this method already runs on a
  // background isolate. If we used MoorIsolate.spawn, a third isolate would be
  // started which is not what we want!
  final moorIsolate = MoorIsolate.inCurrent(() => DatabaseConnection.fromExecutor(executor));
  // inform the starting isolate about this, so that it can call .connect()
  request.sendMoorIsolate.send(moorIsolate);
}

@module
abstract class GraduateDBModule {
  @preResolve
  @singleton
  Future<MoorIsolate> getMoorIsolate() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, databaseFileName);
    final receivePort = ReceivePort();

    await Isolate.spawn(
      _startBackground,
      _IsolateStartRequest(sendMoorIsolate: receivePort.sendPort, targetPath: path, isDebugMode: kDebugMode),
    );

    // _startBackground will send the MoorIsolate to this ReceivePort
    return await receivePort.first as MoorIsolate;
  }

  @preResolve
  @singleton
  Future<GraduateDB> getDb(MoorIsolate isolate) async {
    return GraduateDB.connect(await isolate.connect());
  }
  // @singleton
  // GraduateDB placesDao(GraduateDB db) => GraduateDB.connect(DatabaseConnection.delayed(_connectAsync()));
}

class _IsolateStartRequest {
  const _IsolateStartRequest({
    required this.sendMoorIsolate,
    required this.targetPath,
    required this.isDebugMode,
  });
  final SendPort sendMoorIsolate;
  final String targetPath;
  final bool isDebugMode;
}
