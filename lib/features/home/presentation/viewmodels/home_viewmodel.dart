import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/extensions/string.dart';
import 'package:flutter/cupertino.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/models/pagination_response.dart';
import 'package:graduation_project/base/data/models/search_result_model.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/interactors/search_observer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:moor/moor.dart';

part 'home_viewmodel.g.dart';

const int _IMAGE_QUALITY = 50;
const double _IMAGE_WIDTH = 500.0;
const double _IMAGE_HEIGHT = 500.0;

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
    filterObserver = autorun((_) {
      logger.d('change modifire to $imageSource, text: $query, image: $path, sim: $serverPath');
      search(fresh: true);
    });
  }

  final SearchObserver _searchObserver;
  final ImagePicker _picker = ImagePicker();

  int page = 1;

  late final ReactionDisposer filterObserver;

  //* OBSERVERS *//
  @observable
  String? query;
  @observable
  String? path;
  @observable
  String? serverPath;

  @observable
  BackupModifier imageSource = BackupModifier.PRIVATE;

  @observable
  ObservableStream<PaginationResponse<SearchResultModel>>? searchResult;

  //* COMPUTED *//

  @computed
  bool get textMode => query != null;

  @computed
  bool get imageMode => path != null;

  @computed
  bool get simMode => serverPath != null;

  @computed
  bool get recommendationsMode => !textMode && !imageMode && !simMode;

  @computed
  ValueKey get listKey {
    if (textMode) {
      return ValueKey('home_text_search' + imageSource.localizationKey);
    }
    if (imageMode) {
      return ValueKey('home_image_search' + imageSource.localizationKey);
    }
    if (simMode) {
      return ValueKey('home_sim_search' + imageSource.localizationKey);
    }

    if (recommendationsMode) {
      return const ValueKey('home_recomm_search' /*  + imageSource.localizationKey */);
    }

    return const ValueKey('home_undefiend');
  }

  //* ACTIONS *//

  @action
  void toggleImageSource() => imageSource = imageSource.negate;

  @action
  void getRecommendations() {
    clearSearch(text: true, image: true, sim: true);
    // search(fresh: true);
  }

  @action
  void searchByText(String query) {
    this.query = query;
    clearSearch(text: query.isNullOrEmpty, image: true, sim: true);
  }

  @action
  void searchBySimiliraty(String serverPath) {
    this.serverPath = serverPath;
    clearSearch(text: true, image: true);
  }

  @action
  Future<void> searchByImage(int index) async {
    final image = await _picker.pickImage(
      source: index == 0 ? ImageSource.camera : ImageSource.gallery,
      imageQuality: _IMAGE_QUALITY,
      maxHeight: _IMAGE_HEIGHT,
      maxWidth: _IMAGE_WIDTH,
    );
    if (image != null) {
      path = image.path;
      clearSearch(text: true, sim: true);
    }
  }

  @action
  void search({fresh = false}) {
    if (fresh || _searchObserver.canLoadMore) {
      if (textMode && query.isNullOrEmpty) {
        return;
      }
      _searchObserver(SearchObserver.params(
        backupModifier: imageSource,
        query: query,
        path: path,
        fresh: fresh,
        serverPath: serverPath,
      ));
    }
  }

  @action
  void clearSearch({bool text = false, bool image = false, bool sim = false}) {
    if (text) {
      query = null;
    }

    if (image) {
      path = null;
    }

    if (sim) {
      serverPath = null;
    }
  }

  @override
  Future<void> dispose() {
    filterObserver();
    return super.dispose();
  }
}
