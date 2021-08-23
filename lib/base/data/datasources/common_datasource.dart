import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:core_sdk/utils/network_result.dart';
import 'package:graduation_project/base/data/datasources/graduate_datasource.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/data/models/base_response_model.dart';
import 'package:graduation_project/base/data/models/form_data_model.dart';
import 'package:graduation_project/base/data/models/pagination_response.dart';
import 'package:graduation_project/base/data/models/search_key_model.dart';
import 'package:graduation_project/base/data/models/search_result_model.dart';
import 'package:graduation_project/base/data/models/upload_model.dart';
import 'package:graduation_project/base/utils/end_points.dart';
import 'package:graduation_project/features/backup/networking/networking_isolator.dart';
import 'package:injectable/injectable.dart';

abstract class CommonDataSource extends GraduateDataSource {
  CommonDataSource(NetworkIsolate client) : super(client);

  Future<NetworkResult<BaseResponseModel<UploadModel>?>> uploadImages(List<Backup> images);

  Future<NetworkResult<BaseResponseModel<UploadModel>?>> changeModifire({
    required BackupModifier modifier,
    required String serverPath,
  });

  Future<NetworkResult<BaseResponseModel<PaginationResponse<SearchResultModel>>?>> search({
    required int page,
    required BackupModifier modifier,
    required String? query,
    required String? path,
    required String? serverPath,
  });
}

@LazySingleton(as: CommonDataSource)
class CommonDataSourceImpl extends CommonDataSource {
  CommonDataSourceImpl(NetworkIsolate client) : super(client);

  @override
  Future<NetworkResult<BaseResponseModel<UploadModel>?>> uploadImages(List<Backup> images) async => request(
        method: METHOD.POST,
        endpoint: EndPoints.upload,
        mapper: BaseResponseModel.fromJson(UploadModel.fromJson),
        withAuth: true,
        // path: images.first.path,
        formDataRows: [
          FormDataRow(key: 'file', value: images.first.path),
        ],
      );

  @override
  Future<NetworkResult<BaseResponseModel<UploadModel>?>> changeModifire({
    required BackupModifier modifier,
    required String serverPath,
  }) async =>
      Future.delayed(const Duration(seconds: 2)).then(
        (value) => Success(BaseResponseModel.fromJson(UploadModel.fromJson)({
          'data': {'name': 'ea9c5efd68a06860114999bd12b9be88.jpg', 'type': 'image/jpeg'},
          'status': 200,
        })),
      );

  // request(
  //   method: METHOD.POST,
  //   endpoint: EndPoints.changeModifire,
  //   mapper: BaseResponseModel.fromJson(UploadModel.fromJson),
  //   withAuth: true,
  //   data: {
  //     'name': serverPath,
  //     'public': modifier == BackupModifier.PUBPLIC,
  //   },
  // );

  Future<NetworkResult<BaseResponseModel<PaginationResponse<SearchResultModel>>?>> _getResultByKey({
    required int page,
    required int key,
  }) =>
      request(
        method: METHOD.GET,
        endpoint: EndPoints.getSearchResult + '/$key',
        mapper: BaseResponseModel.fromJsonWithPagination(SearchResultModel.fromJson),
        params: {'page': page},
      );

  @override
  Future<NetworkResult<BaseResponseModel<PaginationResponse<SearchResultModel>>?>> search({
    required int page,
    required BackupModifier modifier,
    required String? query,
    required String? path,
    required String? serverPath,
  }) async {
    if (query == null && path == null && serverPath == null)
      return request(
        method: METHOD.GET,
        endpoint: EndPoints.recommendations,
        mapper: BaseResponseModel.fromJsonWithPagination(SearchResultModel.fromJson),
        params: {'page': page},
      );
    final res = await request(
      method: METHOD.POST,
      endpoint: query != null
          ? EndPoints.textToImage
          : serverPath == null
              ? EndPoints.imageToImage
              : EndPoints.getSimilar,
      mapper: BaseResponseModel.fromJson(SearchKeyModel.fromJson),
      data: {
        if (query != null) 'text': query,
        if (serverPath != null) 'name': serverPath,
        if (modifier == BackupModifier.PUBPLIC) 'isPublic': true,
      },
      // path: path,
      formDataRows: path != null
          ? [
              FormDataRow(key: 'image', value: path),
            ]
          : null,
    );

    return _getResultByKey(
      key: res.getOrThrow()!.data!.key!,
      page: page,
    );
  }

  // @override
  // Future<NetworkResult<BaseResponseModel<PaginationResponse<SearchResultModel>>?>> searchBySimilarity({
  //   required int page,
  //   required BackupModifier modifier,
  //   required String serverPath,
  // }) async {
  //   final res = await request(
  //     method: METHOD.POST,
  //     endpoint: EndPoints.getSearchResult,
  //     mapper: BaseResponseModel.fromJson(SearchKeyModel.fromJson),
  //     data: {
  //       'name': serverPath,
  //       if (modifier == BackupModifier.PUBPLIC) 'isPublic': true,
  //     },
  //   );

  //   return _getResultByKey(
  //     key: res.getOrThrow()!.data!.key!,
  //     page: page,
  //   );
  // }
}
