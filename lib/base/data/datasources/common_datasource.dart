import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:core_sdk/utils/network_result.dart';
import 'package:graduation_project/base/data/datasources/graduate_datasource.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/data/models/base_response_model.dart';
import 'package:graduation_project/base/utils/end_points.dart';
import 'package:graduation_project/features/backup/networking/networking_isolator.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

abstract class CommonDataSource extends GraduateDataSource {
  CommonDataSource(NetworkIsolate client) : super(client);

  Future<NetworkResult<bool?>> uploadImages(List<Backup> images);
}

@LazySingleton(as: CommonDataSource)
class CommonDataSourceImpl extends CommonDataSource {
  CommonDataSourceImpl(NetworkIsolate client) : super(client);

  @override
  Future<NetworkResult<bool?>> uploadImages(List<Backup> images) async => request(
        method: METHOD.POST,
        endpoint: EndPoints.upload,
        mapper: BaseResponseModel.successMapper,
        withAuth: true,
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(
            images.first.path,
            filename: images.first.path.split('/').last,
          ),
        }),
      );
}
