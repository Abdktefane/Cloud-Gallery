import 'dart:io';

import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/app/app.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/base/ext/widget_ext.dart';
import 'package:graduation_project/base/utils/image_url_provider.dart';
import 'package:graduation_project/features/backup/presentation/widgets/backup_tile.dart';
import 'package:graduation_project/features/backup/presentation/widgets/hero_photo_view.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageTile extends StatefulWidget {
  ImageTile({
    Key? key,
    required this.imageUrlProvider,
    required this.serverPath,
    required this.token,
    required this.searchByImage,
  }) : super(key: key) {}

  final ImageUrlProvider imageUrlProvider;
  final String serverPath;
  final Future<String?> token;
  ValueChanged<String> searchByImage;

  @override
  _ImageTileState createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  final CustomPopupMenuController _menuController = CustomPopupMenuController();
  late final List<ItemModel> menuItems;

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
        icon: Icons.search,
        title: 'lbl_search',
        onPress: () {
          widget.searchByImage(widget.serverPath);
          _menuController.hideMenu();
        },
      ),
    ];
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      barrierColor: Colors.transparent,
      pressType: PressType.singleClick,
      menuBuilder: _buildMenuItems,
      controller: _menuController,
      position: PreferredPosition.top,
      showArrow: true,
      arrowSize: 18.0,
      horizontalMargin: 0,
      verticalMargin: 0,
      child: FutureBuilder(
        future: widget.token,
        builder: (_, snapShot) => snapShot.connectionState == ConnectionState.done
            ? FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(
                  widget.imageUrlProvider.get(widget.serverPath),
                  headers: {'Authorization': (snapShot.data as String?) ?? ''},
                ),
                fit: BoxFit.cover,
              ).clip(borderRadius: const BorderRadius.all(Radius.circular(15)))
            : const SizedBox(),
      ),
    );
  }

  Future<void> openImage() async {
    App.navKey.currentContext?.pushPage(HeroPhotoViewRouteWrapper(
      imageProvider: Image.network(
        widget.imageUrlProvider.get(widget.serverPath),
        headers: {'Authorization': await widget.token ?? ''},
      ).image,
      tag: widget.serverPath,
    ));
  }

  Widget _buildMenuItems() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 150,
        color: const Color(0xFF4C4C4C),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: menuItems
              .map(
                (item) => GestureDetector(
                  onTap: item.onPress,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        item.icon,
                        size: 20,
                        color: Colors.white,
                      ),
                      Text(
                        context.translate(item.title),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ).padding(padding: const EdgeInsets.symmetric(vertical: 2.0)),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
