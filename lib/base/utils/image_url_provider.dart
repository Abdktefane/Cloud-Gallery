import 'package:injectable/injectable.dart';

@singleton
class ImageUrlProvider {
  ImageUrlProvider(@Named('ApiBaseUrl') this.baseUrl);
  final String baseUrl;

  String get(String name) => '$baseUrl/files/$name';
}
