import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:injectable/injectable.dart';

@singleton
class ImageSaver {
  ImageSaver(this._prefsRepository) {
    _uploadedImages = _prefsRepository.uploadedFiles ?? [];
  }

  final PrefsRepository _prefsRepository;
  late final List<String> _uploadedImages;

  bool isUploaded(String path) => _uploadedImages.contains(path);

  Future<bool> save(String path) => _prefsRepository.setUploadedFiles(_uploadedImages);
}
