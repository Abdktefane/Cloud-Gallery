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

  @override
  Future<NetworkResult<BaseResponseModel<PaginationResponse<SearchResultModel>>?>> search({
    required int page,
    required BackupModifier modifier,
    required String? query,
    required String? path,
  }) async {
    final res = await request(
      method: METHOD.POST,
      endpoint: query == null ? EndPoints.imageToImage : EndPoints.textToImage,
      mapper: BaseResponseModel.fromJson(SearchKeyModel.fromJson),
      data: {
        'text': query,
        if (modifier == BackupModifier.PUBPLIC) 'isPublic': true,
      },
      // path: path,
      formDataRows: path != null
          ? [
              FormDataRow(key: 'image', value: path),
            ]
          : null,
    );

    return request(
      method: METHOD.GET,
      endpoint: EndPoints.getSearchResult + '/${res.getOrThrow()!.data!.key}',
      params: {'page': page},
      mapper: BaseResponseModel.fromJsonWithPagination(SearchResultModel.fromJson),
    );
  }
}
