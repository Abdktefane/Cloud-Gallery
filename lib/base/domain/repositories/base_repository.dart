import 'package:graduation_project/features/backup/networking/base_isolate_datasource.dart';

// TODO(abd): move this to core sdk
// TODO(abd): find way to make both isolate datasource and regular one extends one contract
// TODO(abd): find way to make DataStore cleaner way to follow clean arch
abstract class BaseRepository {
  const BaseRepository(this.baseRemoteDataSource);

  final BaseIsolateDataSource baseRemoteDataSource;
}
