// import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
// import 'package:core_sdk/utils/Fimber/Logger.dart';
// import 'package:dio/dio.dart';

// enum METHOD { GET, POST, PUT, DELETE }

// typedef Mapper<T> = T Function(Object?);

// abstract class BaseIsolateDataSource {
//   Future<Response> performGetRequest({
//     required String endpoint,
//     Map<String, dynamic>? params,
//     Options? options,
//   });

//   Future<Response> performPostRequest({
//     required String endpoint,
//     required data,
//     Map<String, dynamic>? params,
//     Options? options,
//   });

//   Future<Response> performPutRequest({
//     required String endpoint,
//     required data,
//     Map<String, dynamic>? params,
//     Options? options,
//   });

//   Future<Response> performDeleteRequest({
//     required String endpoint,
//     Map<String, dynamic>? params,
//     Options? options,
//   });

//   Map<String, dynamic> wrapWithBaseData(dynamic data);
// }


// abstract class BaseIsolateDataSourceImpl implements BaseRemoteDataSource {
//   final NetworkIsolate client;
//   // final DataConnectionChecker connectionChecker;
//   final Logger logger;

//   BaseRemoteDataSourceImpl({
//     required this.client,
//     // @required this.connectionChecker,
//     required this.logger,
//   });

//   Future<NetworkResult<T?>> request<T>({
//     required METHOD method,
//     required String endpoint,
//     data,
//     int? siteId,
//     Map<String, dynamic>? params,
//     Map<String, dynamic>? headers,
//     Mapper<T?>? mapper,
//     String? messageErrorKey = 'msg_something_wrong',
//     // String messageErrorKey,
//     bool withAuth = true,
//     bool wrapData = true,
//   }) async {
//     return await _checkNetwork<T?>(() async {
//       late Response response;
//       dynamic jsonResponse;
//       try {
//         Options options = withAuth ? TokenOption.toOptions().copyWith(headers: headers) : Options(headers: headers);
//         print('data = $data');
//         print('endpoint = $endpoint');

//         switch (method) {
//           case METHOD.GET:
//             response = await performGetRequest(
//               endpoint: endpoint,
//               params: params,
//               options: options,
//             );
//             break;
//           case METHOD.POST:
//             response = await performPostRequest(
//               endpoint: endpoint,
//               data: wrapData ? wrapWithBaseData(data) : data,
//               params: params,
//               options: options,
//             );
//             break;
//           case METHOD.PUT:
//             response = await performPutRequest(
//               endpoint: endpoint,
//               data: wrapData ? wrapWithBaseData(data) : data,
//               params: params,
//               options: options,
//             );
//             break;
//           case METHOD.DELETE:
//             response = await performDeleteRequest(
//               endpoint: endpoint,
//               data: wrapData ? wrapWithBaseData(data) : data,
//               params: params,
//               options: options,
//             );
//             break;
//         }
//         // logger.d('my debug here ==> $response');

//         jsonResponse = jsonDecode(response.data);
//         print("my debug res is $jsonResponse");
//         if (jsonResponse is! Map && mapper == null) {
//           return Success(jsonResponse as T?);
//         }

//         if (mapper == null) {
//           return Success<T?>(null);
//         }

//         if (jsonResponse['message'] != null && (jsonResponse['status'] as int?) != 200)
//           throw ServerException(jsonResponse['message'] ?? 'msg_something_wrong');
//         // throw ServerException(jsonResponse['message'] ?? messageErrorKey);
//         final value = mapper(jsonResponse);

//         return Success(value);
//       } catch (e) {
//         //logger.e('my debug new error $response $jsonResponse');
//         logger.e('BaseDataSourceWithMapperImpl => request<$T> => ERROR = $e');
//         // logger.e('BaseDataSourceWithMapperImpl => ERROR: ${(e as? ServerException)?.message}');
//         try {
//           //return NetworkError(ServerFailure(response['message']));
//           return NetworkError(ServerFailure(jsonResponse['message']));
//         } catch (ex) {
//           logger.e(
//               'BaseDataSourceWithMapperImpl FINAL CATCH ERROR => request<$T> => ERROR = e:$e \n $response \n $jsonResponse');
//           return e is ServerException
//               ? NetworkError(ServerFailure(e.message))
//               : NetworkError(ServerFailure(e is String ? e : messageErrorKey));
//           // : NetworkError(ServerFailure(e?.message ?? messageErrorKey));
//         }
//       }
//     });
//   }

//   Future<NetworkResult<T>> _checkNetwork<T>(
//     Future<NetworkResult<T>> Function() body,
//   ) async {
//     return body();
//   }

//   @override
//   Future<Response> performGetRequest({
//     required String endpoint,
//     Map<String, dynamic>? params,
//     Options? options,
//   }) async {
//     try {
//       var response = await client.get(
//         endpoint,
//         queryParameters: params ?? {},
//         options: (options ?? Options()),
//       );
//       if (response.statusCode == STATUS_OK) {
//         logger.d('BaseRemoteDataSourceImpl => performGetRequest => STATUS_OK');
//         return response;
//       } else {
//         logger.e('BaseRemoteDataSourceImpl => performGetRequest => StatusCode = ${response.statusCode}');
//         throw ServerException('msg_http_exception');
//       }
//     } catch (e) {
//       logger.e('BaseRemoteDataSourceImpl => performGetRequest => $e');

//       throw e is ServerException ? ServerException(e.message) : ServerException('msg_something_wrong');
//     }
//   }

//   @override
//   Future<Response> performPostRequest({
//     required String endpoint,
//     required data,
//     Map<String, dynamic>? params,
//     Options? options,
//   }) async {
//     try {
//       final response = await client.post(
//         endpoint,
//         data: data,
//         queryParameters: params ?? {},
//         options: options,
//       );
//       if (response.statusCode == STATUS_OK) {
//         logger.w('BaseRemoteDataSourceImpl => performPostRequest => STATUS_OK');
//         return response;
//       } else {
//         logger.e('BaseRemoteDataSourceImpl => performPostRequest => StatusCode = ${response.statusCode}');
//         throw ServerException('msg_http_exception');
//       }
//     } catch (e) {
//       logger.e('BaseRemoteDataSourceImpl => performPostRequest => $e');
//       throw e is ServerException ? ServerException(e.message) : ServerException('msg_something_wrong');
//     }
//   }

//   @override
//   Future<Response> performPutRequest({
//     required String endpoint,
//     required data,
//     Map<String, dynamic>? params,
//     Options? options,
//   }) async {
//     try {
//       final response = await client.put(
//         endpoint,
//         data: data,
//         queryParameters: params ?? {},
//         options: options,
//       );
//       if (response.statusCode == STATUS_OK) {
//         logger.w('BaseRemoteDataSourceImpl => performPutRequest => STATUS_OK');
//         return response;
//       } else {
//         logger.e('BaseRemoteDataSourceImpl => performPutRequest => StatusCode = ${response.statusCode}');
//         throw ServerException('msg_http_exception');
//       }
//     } catch (e) {
//       logger.e('BaseRemoteDataSourceImpl => performPutRequest => $e');
//       throw e is ServerException ? ServerException(e.message) : ServerException('msg_something_wrong');
//     }
//   }

//   @override
//   Future<Response> performDeleteRequest({
//     required String endpoint,
//     data,
//     Map<String, dynamic>? params,
//     Options? options,
//   }) async {
//     try {
//       final response = await client.delete(
//         endpoint,
//         data: data,
//         queryParameters: params ?? {},
//         options: options,
//       );
//       if (response.statusCode == STATUS_OK) {
//         logger.w('BaseRemoteDataSourceImpl => performDeleteRequest => STATUS_OK');
//         return response;
//       } else {
//         logger.e('BaseRemoteDataSourceImpl => performDeleteRequest => StatusCode = ${response.statusCode}');
//         throw ServerException('msg_http_exception');
//       }
//     } catch (e) {
//       logger.e('BaseRemoteDataSourceImpl => performDeleteRequest => $e');
//       throw e is ServerException ? ServerException(e.message) : ServerException('msg_something_wrong');
//     }
//   }
// }
