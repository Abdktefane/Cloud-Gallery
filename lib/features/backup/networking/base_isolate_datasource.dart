import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:core_sdk/utils/network_result.dart';
import 'package:graduation_project/base/data/models/form_data_model.dart';
import 'package:graduation_project/features/backup/networking/networking_isolator.dart';

// TODO(abd): move to core sdk

typedef ErrorMapper = String Function(Map<String, dynamic>);

mixin NetworkApis {
  Future<NetworkResult<T?>> request<T>({
    required METHOD method,
    required String endpoint,
    required Mapper<T?>? mapper,
    bool withAuth = true,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    dynamic data,
    ErrorMapper? errorMapper,
  });
}

abstract class BaseIsolateDataSource with NetworkApis {
  const BaseIsolateDataSource();

  Map<String, dynamic> wrapWithBaseData(dynamic data);

  // String wrapError(Map<String, dynamic> jsonResponse);
}

abstract class BaseIsolateDataSourceImpl extends BaseIsolateDataSource {
  const BaseIsolateDataSourceImpl(this._networkIsolate);

  final NetworkIsolate _networkIsolate;

  @override
  Future<NetworkResult<T?>> request<T>({
    required METHOD method,
    required String endpoint,
    required Mapper<T?>? mapper,
    bool withAuth = true,
    bool wrapData = false,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    data,
    ErrorMapper? errorMapper,
    List<FormDataRow>? formDataRows,
  }) =>
      _networkIsolate.request(
        method: method,
        endpoint: endpoint,
        mapper: mapper,
        withAuth: withAuth,
        data: wrapData ? wrapWithBaseData(data) : data,
        errorMapper: errorMapper,
        headers: headers,
        params: params,
        formDataRows: formDataRows,
      );
}
