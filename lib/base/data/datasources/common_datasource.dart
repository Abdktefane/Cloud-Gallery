import 'dart:convert';
import 'dart:io';

import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:core_sdk/error/exceptions.dart';
import 'package:core_sdk/error/failures.dart';
import 'package:core_sdk/utils/network_result.dart';
// import 'package:flutter_media_store/media_store.dart';
import 'package:graduation_project/app/di/injection_container.dart';
import 'package:graduation_project/base/data/datasources/graduate_datasource.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/data/models/base_response_model.dart';
import 'package:graduation_project/base/data/models/form_data_model.dart';
import 'package:graduation_project/base/data/models/pagination_response.dart';
import 'package:graduation_project/base/data/models/search_key_model.dart';
import 'package:graduation_project/base/data/models/search_result_model.dart';
import 'package:graduation_project/base/data/models/upload_model.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:graduation_project/base/utils/end_points.dart';
import 'package:graduation_project/features/backup/domain/interactors/image_sync_interactor.dart';
import 'package:graduation_project/features/backup/networking/networking_isolator.dart';
// import 'package:image_downloader/image_downloader.dart';
import 'package:injectable/injectable.dart';
import 'package:media_store/media_store.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:image_downloader/image_downloader.dart';
import 'package:photo_manager/photo_manager.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:media_store/media_store.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:media_store/media_store.dart';

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

  Future<NetworkResult<BaseResponseModel<PaginationResponse<BackupsCompanion>>?>> getServerImages({
    required int page,
    required int pageSize,
    required BackupModifier modifier,
    DateTime? lastSync,
  });

  Future<NetworkResult<bool?>> downloadFile({
    required String serverPath,
    required String localStoragePath,
  });
}

@LazySingleton(as: CommonDataSource)
class CommonDataSourceImpl extends CommonDataSource {
  CommonDataSourceImpl(NetworkIsolate client, this._prefsRepository) : super(client);

  final PrefsRepository _prefsRepository;

  @override
  Future<NetworkResult<BaseResponseModel<UploadModel>?>> uploadImages(List<Backup> images) async => request(
        method: METHOD.POST,
        endpoint: EndPoints.upload,
        mapper: BaseResponseModel.fromJson(UploadModel.fromJson),
        withAuth: true,
        formDataRows: [
          FormDataRow(key: 'file', value: images.first.path ?? ''),
          FormDataRow(key: 'identifier', value: images.first.id, isImage: false),
          FormDataRow(key: 'thump', value: base64.encode(images.first.thumbData), isImage: false),
        ],
      );

  @override
  Future<NetworkResult<BaseResponseModel<UploadModel>?>> changeModifire({
    required BackupModifier modifier,
    required String serverPath,
  }) async =>
      // Future.delayed(const Duration(seconds: 2)).then(
      //   (value) => Success(BaseResponseModel.fromJson(UploadModel.fromJson)({
      //     'data': {'name': 'ea9c5efd68a06860114999bd12b9be88.jpg', 'type': 'image/jpeg'},
      //     'status': 200,
      //   })),
      // );

      request(
        method: METHOD.PUT,
        endpoint: EndPoints.upload + '/$serverPath' + '/makePublic',
        mapper: BaseResponseModel.fromJson(UploadModel.fromJson),
        withAuth: true,
        data: {
          'isPublic': modifier == BackupModifier.PUBPLIC,
        },
      );

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
              if (modifier == BackupModifier.PUBPLIC) const FormDataRow(key: 'isPublic', value: 'true', isImage: false),
            ]
          : null,
    );

    return _getResultByKey(
      key: res.getOrThrow()!.data!.key!,
      page: page,
    );
  }

  @override
  Future<NetworkResult<BaseResponseModel<PaginationResponse<BackupsCompanion>>?>> getServerImages({
    required int page,
    required int pageSize,
    required BackupModifier modifier,
    DateTime? lastSync,
  }) {
    return request(
      method: METHOD.GET,
      endpoint: EndPoints.getServerImages,
      mapper: BaseResponseModel.fromJsonWithPagination(BackupsCompanionExt.fromJson),
      params: {
        'page': page,
        'size': pageSize,
        if (lastSync != null) 'startDate': lastSync,
        'order': 'DESC',
      },
    );
  }

  @override
  Future<NetworkResult<bool?>> downloadFile({
    required String serverPath,
    required String localStoragePath,
  }) async {
    await request(
      method: METHOD.DELETE,
      endpoint: EndPoints.upload + '/$serverPath',
      mapper: null,
      data: localStoragePath,
    );
    final AssetEntity? imageEntity = await PhotoManager.editor.saveImageWithPath(
      localStoragePath,
      title: serverPath,
      // relativePath: kSyncFolderName,
    );
    print(imageEntity);

    // if (globalAssetPathEntity != null && imageEntity != null) {
    //   final result = await PhotoManager.editor.copyAssetToPath(
    //     asset: imageEntity,
    //     pathEntity: globalAssetPathEntity!,
    //   );
    //   final res2 = await PhotoManager.editor.android.moveAssetToAnother(
    //     entity: imageEntity,
    //     target: globalAssetPathEntity!,
    //   );
    //   await globalAssetPathEntity?.refreshPathProperties();

    //   print(result);
    //   print(res2);
    // }

    // await PhotoManager.editor.android.moveAssetToAnother(entity: entity, target: target)

    // final result = await MediaStore.saveFile(file: File('localStoragePath'), name: serverPath);

    // MediaStore.

    // final asset = await PhotoManager.editor.saveImage(
    //   File(localStoragePath).readAsBytesSync(),
    //   relativePath: localStoragePath,
    //   title: serverPath,
    // );

    // final mediaStore = MediaStore();
    // await mediaStore.addItem(file: File(localStoragePath), name: serverPath);

    return Success(true);

    // if (await Permission.storage.request().isGranted) {
    //   final taskId = await FlutterDownloader.enqueue(
    //     url: EndPoints.upload + '/$serverPath',
    //     savedDir: localStoragePath,
    //     showNotification: true, // show download progress in status bar (for Android)
    //     openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    //     headers: {'Authorization': _prefsRepository.token!},
    //   );
    //   return Success(true);
    // }

    // return NetworkError(ServerFailure(''));

// FlutterDownloader.open(taskId: taskId)

    // final result = await MediaStore.saveFile(localStoragePath);

    // final result = await ImageGallerySaver.saveFile(localStoragePath);

    // final asset = await ImageDownloader.downloadImage(
    //   baseUrl2 + EndPoints.upload + '/$serverPath',
    //   destination: AndroidDestinationType.custom(directory: localStoragePath),
    //   headers: {'Authorization': _prefsRepository.token!},
    // );

    // print('my debug inserted asset is $asset');

    //  PhotoManager.editor.android.moveAssetToAnother(entity: entity, target: target)
    // try {
    //   final asset = await PhotoManager.editor.saveImageWithPath(
    //     localStoragePath,
    //     relativePath: localStoragePath,
    //     title: serverPath,
    //   );
    //   // asset.relativePath
    //   print('my debug inserted asset is $asset');
    // } catch (ex, st) {
    //   print('ex:$ex,st:$st');
    // }

    // await PhotoManager.editor.saveImageWithPath(localStoragePath);

    // GallerySaver.saveImage(path)
  }
}

extension BackupExt on Backup {
  static Backup fromJson(Object json) => Backup.fromJson(json as Map<String, dynamic>);
}
