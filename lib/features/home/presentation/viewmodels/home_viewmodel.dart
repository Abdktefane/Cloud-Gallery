import 'package:graduation_project/base/domain/repositories/common_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:core_sdk/utils/extensions/string.dart';
import 'package:supercharged/supercharged.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';

part 'home_viewmodel.g.dart';

@injectable
class HomeViewmodel extends _HomeViewmodelBase with _$HomeViewmodel {
  HomeViewmodel(
    Logger logger,
    CommonRepository _commonRepository,
  ) : super(logger, _commonRepository);
}

abstract class _HomeViewmodelBase extends BaseViewmodel with Store {
  _HomeViewmodelBase(Logger logger, this._commonRepository) : super(logger);
  final CommonRepository _commonRepository;

  //* OBSERVERS *//

  //* COMPUTED *//

  //* ACTIONS *//

}
