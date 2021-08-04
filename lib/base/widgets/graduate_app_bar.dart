import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/app/viewmodels/app_viewmodel.dart';

class GraduateAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GraduateAppBar({
    Key? key,
    this.title,
    required this.appViewModel,
  }) : super(key: key);

  final AppViewmodel? appViewModel;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: WHITE,
            // border: Border(bottom: BorderSide(color: BORDER_COLOR)),
          ),
          child: AppBar(
            title: Text(
                title ??
                    (appViewModel!.appBarParams!.translateTitle
                        ? context.translate(appViewModel!.appBarParams!.title)
                        : appViewModel!.appBarParams!.title),
                style: context.textTheme.bodyText1!.copyWith(
                  color: TEXT_COLOR,
                  fontWeight: FontWeight.w500,
                  fontSize: 19,
                  letterSpacing: 0.15,
                )),
            toolbarHeight: 56.0,
            elevation: 0,
            //leadingWidth: 30,
            centerTitle: false,
            leading: title != null || appViewModel!.appBarParams!.showBackButton
                ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => appViewModel!.popRoute(
                      context,
                      onBackPressed: appViewModel!.appBarParams!.onBackPressed,
                    ),
                  )
                : null,

            backgroundColor: appViewModel!.appBarParams!.backgroundColor,
            actionsIconTheme: const IconThemeData(color: GREY),
            iconTheme: const IconThemeData(color: Colors.black),
            bottom: appViewModel!.appBarParams!.bottom,
            actions: title != null ? null : null,
            // : appViewModel.appBarParams.showNotificationIcon
            //     ? [
            //         Observer(
            //           builder: (_) {
            //             return navigationButtonWithCount(
            //               context,
            //               icon: Icons.notifications,
            //               count: appViewModel.notificationsCount,
            //               onPressed: () => context.cupertinoPushPage(
            //                 NotificationsPage(appViewModel: appViewModel),
            //               ),
            //             );
            //           },
            //         )
            //       ]
            //     : null,
          ),
        );
      },
    );
  }

  Widget navigationButtonWithCount(
    BuildContext context, {
    String? routeName,
    IconData? icon,
    required int count,
    VoidCallback? onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          IconButton(
            icon: Icon(
              icon,
              size: 24.0,
              color: DARK_GREY,
            ),
            onPressed: onPressed,
          ),
          if (count > 0)
            Container(
              width: 20.0,
              height: 20.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: RED,
              ),
              child: Center(
                child: Text(
                  count > 10 ? '+10' : count.toString(),
                  style: TextStyle(color: WHITE, fontSize: count > 10 ? 8 : 10),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
