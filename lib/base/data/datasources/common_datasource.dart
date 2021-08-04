import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:graduation_project/base/data/datasources/graduate_datasource.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

abstract class CommonDataSource extends GraduateDataSource {
  CommonDataSource({
    required Dio client,
    required PrefsRepository prefsRepository,
    required Logger logger,
  }) : super(
          prefsRepository: prefsRepository,
          client: client,
          logger: logger,
        );
}

@LazySingleton(as: CommonDataSource)
class CommonDataSourceImpl extends CommonDataSource {
  CommonDataSourceImpl({
    required Dio client,
    required PrefsRepository prefsRepository,
    required Logger logger,
  }) : super(
          prefsRepository: prefsRepository,
          client: client,
          logger: logger,
        );
}
