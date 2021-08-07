import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:graduation_project/features/backup/presentation/viewmodels/backup_image_ui_model.dart';

class BackupImageTile extends StatelessWidget {
  const BackupImageTile({
    Key? key,
    required this.model,
  }) : super(key: key);
  final BackupImageUIModel model;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${model.image.id}, ${model.status}'),
      leading: FutureBuilder(
        future: model.image.thumbData,
        builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Image.memory(snapshot.data!);
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
