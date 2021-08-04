import 'package:graduation_project/base/domain/repositories/common_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:core_sdk/utils/extensions/string.dart';
import 'package:supercharged/supercharged.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';

part 'backup_viewmodel.g.dart';

@injectable
class BackupViewmodel extends _BackupViewmodelBase with _$BackupViewmodel {
  BackupViewmodel(
    Logger logger,
    CommonRepository _commonRepository,
  ) : super(logger, _commonRepository);
}

abstract class _BackupViewmodelBase extends BaseViewmodel with Store {
  _BackupViewmodelBase(Logger logger, this._commonRepository) : super(logger);
  final CommonRepository _commonRepository;

  //* OBSERVERS *//

  //* COMPUTED *//

  //* ACTIONS *//

}
