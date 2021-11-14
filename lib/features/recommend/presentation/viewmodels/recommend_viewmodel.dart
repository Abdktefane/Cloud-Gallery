import 'package:graduation_project/base/domain/repositories/common_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:core_sdk/utils/extensions/string.dart';
import 'package:supercharged/supercharged.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';

part 'recommend_viewmodel.g.dart';

@injectable
class RecommendViewmodel extends _RecommendViewmodelBase with _$RecommendViewmodel {
  RecommendViewmodel(
    Logger logger,
    CommonRepository _commonRepository,
  ) : super(logger, _commonRepository);
}

abstract class _RecommendViewmodelBase extends BaseViewmodel with Store {
  _RecommendViewmodelBase(Logger logger, this._commonRepository) : super(logger);
  final CommonRepository _commonRepository;

  //* OBSERVERS *//

  //* COMPUTED *//

  //* ACTIONS *//

}
