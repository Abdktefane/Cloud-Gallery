import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/models/pagination_response.dart';
import 'package:graduation_project/base/data/models/search_result_model.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/interactors/search_observer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'home_viewmodel.g.dart';

@injectable
class HomeViewmodel extends _HomeViewmodelBase with _$HomeViewmodel {
  HomeViewmodel(
    Logger logger,
    SearchObserver searchObserver,
  ) : super(logger, searchObserver);
}

abstract class _HomeViewmodelBase extends BaseViewmodel with Store {
  _HomeViewmodelBase(Logger logger, this._searchObserver) : super(logger) {
    searchResult = _searchObserver.asObservable();
    // filterObserver = autorun((_) {
    //   logger.d('change modifire to $imageSource');
    //   search(fresh: true);
    // });
  }

  final SearchObserver _searchObserver;
  final ImagePicker _picker = ImagePicker();

  int page = 1;

  // late final ReactionDisposer filterObserver;

  //* OBSERVERS *//
  @observable
  BackupModifier imageSource = BackupModifier.PRIVATE;

  @observable
  ObservableStream<PaginationResponse<SearchResultModel>>? searchResult;

  //* COMPUTED *//

  //* ACTIONS *//

  String? query;
  String? path;
  String? serverPath;

  @action
  void toggleImageSource() => imageSource = imageSource.negate;

  @action
  void searchByText(String query) {
    this.query = query;
    path = null;
    serverPath = null;
    search(fresh: true);
  }

  @action
  void searchBySimiliraty(String serverPath) {
    this.serverPath = serverPath;
    path = null;
    query = null;
    search(fresh: true);
  }

  @action
  Future<void> searchByImage(int index) async {
    final XFile? image = await _picker.pickImage(source: index == 0 ? ImageSource.camera : ImageSource.gallery);
    path = image?.path;
    query = null;
    serverPath = null;
    search(fresh: true);
  }

  @action
  void search({fresh = false}) {
    _searchObserver(SearchObserver.params(
      backupModifier: imageSource,
      query: query,
      path: path,
      fresh: fresh,
      serverPath: serverPath,
    ));
  }

  @override
  Future<void> dispose() {
    // filterObserver();
    return super.dispose();
  }
}
