import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/models/pagination_response.dart';
import 'package:graduation_project/base/data/models/search_result_model.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/base/domain/repositories/common_repository.dart';
import 'package:graduation_project/base/widgets/strream_observer.dart';
import 'package:graduation_project/features/backup/domain/interactors/search_observer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'home_viewmodel.g.dart';

@injectable
class HomeViewmodel extends _HomeViewmodelBase with _$HomeViewmodel {
  HomeViewmodel(
    Logger logger,
    CommonRepository _commonRepository,
    SearchObserver searchObserver,
  ) : super(logger, _commonRepository, searchObserver);
}

abstract class _HomeViewmodelBase extends BaseViewmodel with Store {
  _HomeViewmodelBase(Logger logger, this._commonRepository, this._searchObserver) : super(logger) {
    searchResult = _searchObserver.asObservable();
  }
  final CommonRepository _commonRepository;
  final SearchObserver _searchObserver;
  final ImagePicker _picker = ImagePicker();

  int page = 1;

  //* OBSERVERS *//
  @observable
  BackupModifier imageSource = BackupModifier.PRIVATE;

  @observable
  ObservableStream<PaginationResponse<SearchResultModel>>? searchResult;

  //* COMPUTED *//

  //* ACTIONS *//

  String? query;
  String? path;

  @action
  void toggleImageSource() => imageSource = imageSource.negate;

  @action
  void searchByText(String query) {
    this.query = query;
    path = null;
    search(fresh: true);
  }

  @action
  Future<void> searchByImage(int index) async {
    final XFile? image = await _picker.pickImage(source: index == 0 ? ImageSource.camera : ImageSource.gallery);
    path = image?.path;
    query = null;
    search(fresh: true);
  }

  @action
  void search({fresh = false}) {
    _searchObserver(SearchObserver.params(
      backupModifier: imageSource,
      query: query,
      path: path,
      fresh: fresh,
    ));
  }
}
