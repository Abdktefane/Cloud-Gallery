import 'dart:io';

import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/app/app.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/ext/widget_ext.dart';
import 'package:graduation_project/features/backup/presentation/widgets/hero_photo_view.dart';

class BackupTile extends StatelessWidget {
  const BackupTile({
    Key? key,
    required this.backup,
  }) : super(key: key);
  final Backup backup;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: backup.assetId,
        transitionOnUserGestures: true,
        child: CircleAvatar(
          backgroundImage: Image.memory(backup.thumbData).image,
          radius: 24.0,
        ),
      ),
      trailing: ShaderMask(
        shaderCallback: (Rect bounds) => linearGradient,
        child: Icon(backup.status.icon, color: PRIMARY),
      ),
      title: Text(backup.title ?? ''),
      onTap: () => App.navKey.currentContext?.pushPage(HeroPhotoViewRouteWrapper(
        imageProvider: Image.file(File('/storage/emulated/0/${backup.path + (backup.title ?? '')}')).image,
        tag: backup.assetId,
      )),
    ).modifier(
      decoration: const BoxDecoration(color: WHITE),
      margin: const EdgeInsets.only(bottom: 8.0),
    );
  }
}
