import 'package:core_sdk/utils/extensions/list.dart';
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

  static _Params params({
    required BackupModifier backupModifier,
    required String? query,
    required String? path,
    required bool fresh,
  }) =>
      _Params(
        backupModifier: backupModifier,
        path: path,
        query: query,
        fresh: fresh,
      );

  @override
  Stream<PaginationResponse<SearchResultModel>> createObservable(_Params params) {
    final stream = Stream.fromFuture(_backupsRepository.search(
      page: params.fresh || valueOrNull == null ? 1 : (valueOrNull?.page ?? 0) + 1,
      modifier: params.backupModifier,
      query: params.query,
      path: params.path,
    ));

    return stream.map((event) {
      if (event.isSuccess && event.getOrNull()?.data.isNullOrEmpty == false) {
        final PaginationResponse<SearchResultModel>? newData = event.getOrThrow();
        return newData!.copyWith(data: (outputStream?.valueOrNull?.data ?? [])..addAll(newData.data!));
      } else {
        return event.getOrThrow()!;
      }
    });
  }
}

class _Params {
  const _Params({
    required this.backupModifier,
    required this.query,
    required this.path,
    this.fresh = false,
    this.page = 1,
  });

  final BackupModifier backupModifier;
  final String? query;
  final String? path;
  final bool fresh;
  final int page;
}
