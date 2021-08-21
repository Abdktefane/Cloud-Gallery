import 'dart:io';

import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/app/app.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/ext/widget_ext.dart';
import 'package:graduation_project/features/backup/presentation/widgets/hero_photo_view.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';

class BackupTile extends StatefulWidget {
  const BackupTile({
    Key? key,
    required this.backup,
    required this.toggleModifier,
    required this.searchByImage,
  }) : super(key: key);
  final Backup backup;
  final ValueChanged<BackupModifier> toggleModifier;
  final ValueChanged<String> searchByImage;

  @override
  _BackupTileState createState() => _BackupTileState();
}

class _BackupTileState extends State<BackupTile> {
  bool get showModifireActions => widget.backup.status == BackupStatus.UPLOADED;
  Backup get backup => widget.backup;

  late final List<ItemModel> menuItems;
  final CustomPopupMenuController _menuController = CustomPopupMenuController();
  ValueChanged<String> get searchByImage => widget.searchByImage;

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    menuItems = [
      ItemModel(
        icon: Icons.image,
        title: 'lbl_show_image',
        onPress: () {
          openImage();
          _menuController.hideMenu();
        },
      ),
      ItemModel(
        icon: Icons.toggle_on_rounded,
        title: 'lbl_toggle',
        onPress: () {
          widget.toggleModifier(backup.modifier);
          _menuController.hideMenu();
        },
      ),
      ItemModel(
        icon: Icons.search,
        title: 'lbl_search',
        onPress: () {
          widget.searchByImage(backup.serverPath!);
          _menuController.hideMenu();
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final child = ListTile(
      leading: _builImage(),
      trailing: ShaderMask(
        shaderCallback: (Rect bounds) => linearGradient,
        child: Icon(widget.backup.status.icon, color: PRIMARY),
      ),
      title: Text(widget.backup.title ?? ''),
      // onTap: showModifireActions ? openMenu : openImage,
      onTap: () => _menuController.showMenu(),
    ).modifier(decoration: const BoxDecoration(color: WHITE));

    if (!showModifireActions) {
      return child;
    }

    return CustomPopupMenu(
      barrierColor: Colors.transparent,
      pressType: PressType.singleClick,
      menuBuilder: _buildMenuItems,
      controller: _menuController,
      position: PreferredPosition.top,
      showArrow: false,
      horizontalMargin: 0,
      verticalMargin: 0,
      child: child,
    );
  }

  Widget _builImage() {
    final hero = Hero(
      tag: widget.backup.assetId,
      transitionOnUserGestures: true,
      child: CircleAvatar(backgroundImage: Image.memory(widget.backup.thumbData).image, radius: 24.0),
    );

    if (showModifireActions) {
      return GestureDetector(onTap: openImage, child: hero);
    }
    return hero;
  }

  void openImage() {
    App.navKey.currentContext?.pushPage(HeroPhotoViewRouteWrapper(
      imageProvider: Image.file(File(widget.backup.path)).image,
      tag: widget.backup.assetId,
    ));
  }

  Widget _buildMenuItems() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 200,
        color: const Color(0xFF4C4C4C),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: menuItems
              .map((item) => GestureDetector(
                    onTap: item.onPress,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          item.icon,
                          size: 20,
                          color: Colors.white,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          child: Text(
                            item.title,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void openMenu() {}
}

class ItemModel {
  const ItemModel({required this.title, required this.icon, required this.onPress});
  final String title;
  final IconData icon;
  final VoidCallback onPress;
}
