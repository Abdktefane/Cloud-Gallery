import 'package:core_sdk/utils/network_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/models/pagination_response.dart';
import 'package:graduation_project/base/data/models/search_result_model.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchObserver extends SubjectInteractor<_Params, PaginationResponse<SearchResultModel>> {
  SearchObserver(this._backupsRepository);

  final BackupsRepository _backupsRepository;

  PaginationResponse<SearchResultModel>? get oldData => outputStream?.valueOrNull;

  bool get haveOldData => oldData != null;

  bool get canLoadMore => !haveOldData || oldData!.meta!.currentPage! < oldData!.meta!.lastPage!;

  static _Params params({
    required BackupModifier backupModifier,
    required String? query,
    required String? path,
    required String? serverPath,
    required ValueChanged<String> onError,
    required bool fresh,
  }) =>
      _Params(
        backupModifier: backupModifier,
        path: path,
        query: query,
        fresh: fresh,
        serverPath: serverPath,
        onError: onError,
      );

  @override
  Stream<PaginationResponse<SearchResultModel>> createObservable(_Params params) {
    return Stream.fromFuture(_backupsRepository.search(
      page: params.fresh || valueOrNull == null ? 1 : (oldData?.meta?.currentPage ?? 0) + 1,
      modifier: params.backupModifier,
      query: params.query,
      path: params.path,
      serverPath: params.serverPath,
    )).unwrap;
  }
}

class _Params {
  const _Params({
    required this.backupModifier,
    required this.query,
    required this.path,
    required this.serverPath,
    required this.onError,
    this.fresh = false,
  });

  final BackupModifier backupModifier;
  final String? query;
  final String? path;
  final String? serverPath;
  final bool fresh;
  final ValueChanged<String> onError;
}

extension NetworkStreamData<T> on Stream<NetworkResult<T?>> {
  Stream<T> get unwrap => map((it) {
        print('my deubg unrap map called');
        return it.getOrThrow()!;
      });
}
