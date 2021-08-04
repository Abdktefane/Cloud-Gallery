import 'package:core_sdk/data/repositories/base_repository.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:graduation_project/base/data/datasources/graduate_datasource.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';

abstract class GraduateRepository extends BaseRepository {
  const GraduateRepository({
    required GraduateDataSource dataSource,
    required this.logger,
    required this.prefsRepository,
  }) : super(dataSource);
  final Logger logger;
  final PrefsRepository prefsRepository;
}
