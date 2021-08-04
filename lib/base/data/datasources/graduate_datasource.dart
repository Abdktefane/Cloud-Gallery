import 'package:core_sdk/data/datasource/base_remote_data_source_impl.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';

class GraduateDataSource extends BaseRemoteDataSourceImpl {
  GraduateDataSource({
    required this.client,
    required this.logger,
    required this.prefsRepository,
  }) : super(
          client: client,
          logger: logger,
        );

  final Dio client;
  final Logger logger;
  final PrefsRepository prefsRepository;

  @override
  Map<String, dynamic> wrapWithBaseData(data) {
    // final wrappedData = Map<String, dynamic>();
    // final siteIdParam = prefsRepository.siteId ?? -1;
    // wrappedData['langCode'] = prefsRepository.languageCode ?? LANGUAGE_DEFAULT;
    // if (siteIdParam > 0) wrappedData['siteId'] = siteIdParam;
    // if (data != null) wrappedData['data'] = data;
    // return wrappedData;
    return data;
  }
}
