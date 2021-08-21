import 'package:flutter/material.dart';
import 'package:graduation_project/base/utils/image_url_provider.dart';

class ImageTile extends StatelessWidget {
  const ImageTile({
    Key? key,
    required this.imageUrlProvider,
    required this.serverPath,
  }) : super(key: key);

  final ImageUrlProvider imageUrlProvider;
  final String serverPath;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.network(
        imageUrlProvider.get(serverPath),
        headers: const {
          'Authorization':
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiZW1haWwiOiJ0ZXN0MUB0LmNvbSIsImlhdCI6MTYyOTU2OTk1MX0.auUKVTmPN5gdusewjXWyKnxNSpHlfdF9H4uUP0N072Y'
        },
      ),
    );
  }
}
