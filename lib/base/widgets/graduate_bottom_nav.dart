import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/app/viewmodels/app_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation_project/base/ext/widget_ext.dart';
import 'package:graduation_project/main.dart';

class GraduateBottomNavigationBar extends StatelessWidget {
  const GraduateBottomNavigationBar({Key? key, required this.appViewModel}) : super(key: key);

  final AppViewmodel? appViewModel;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          elevation: 0,
          backgroundColor: WHITE,
          currentIndex: appViewModel!.pageIndex.index,
          onTap: (int index) => appViewModel!.navigateTo(PageIndex.values[index]),
          selectedLabelStyle: const TextStyle(
            fontSize: 12.0,
            // foreground: Paint()..shader = linearGradient,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 10.0),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.black,
          unselectedItemColor: GREY,
          items: [
            bottomNavigationBarTile(
              title: context.translate(getAppBarTitle(PageIndex.home)),
              index: PageIndex.home.index,
              child: const Icon(Icons.home, size: 20.0, color: GREY),
              activeChild: const Icon(Icons.home, size: 20.0, color: Colors.black),
            ),
            if (kShowRec)
              bottomNavigationBarTile(
                title: context.translate(getAppBarTitle(PageIndex.recommendation)),
                index: PageIndex.recommendation.index,
                child: const Icon(Icons.recommend, size: 20.0, color: GREY),
                activeChild: const Icon(Icons.recommend, size: 20.0, color: Colors.black),
              ),
            bottomNavigationBarTile(
              title: context.translate(getAppBarTitle(PageIndex.backup)),
              index: PageIndex.backup.index,
              child: const Icon(Icons.backup, size: 20.0, color: GREY),
              activeChild: const Icon(Icons.backup, size: 20.0, color: Colors.black),
            ),
          ],
        );
      },
    )
        .modifier(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)))
        .clip(borderRadius: BorderRadius.circular(24.0));
  }

  BottomNavigationBarItem bottomNavigationBarTile({
    required String title,
    required int index,
    String? icon,
    Widget? child,
    String? activeIcon,
    Widget? activeChild,
  }) {
    return BottomNavigationBarItem(
      backgroundColor: WHITE,
      icon: addPadding(
        child ??
            SvgPicture.asset(
              icon!,
              width: 24.0,
              height: 20.0,
              fit: BoxFit.cover,
              color: appViewModel!.pageIndex.index == index ? Colors.black : GREY,
            ),
      ),
      activeIcon: addPadding(
        activeChild ??
            SvgPicture.asset(
              activeIcon!,
              width: 24.0,
              height: 20.0,
              fit: BoxFit.cover,
              color: appViewModel!.pageIndex.index == index ? Colors.black : GREY,
            ),
      ),
      label: title,
    );
  }

  Widget addPadding(Widget child) => Padding(padding: const EdgeInsets.only(top: 2.0), child: child);

  Widget navigationButtonWithCount(int index, {required String icon, required int count}) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: const Alignment(0.35, -2),
            children: [
              Center(
                child: SvgPicture.asset(
                  icon,
                  width: 24.0,
                  height: 20.0,
                  fit: BoxFit.cover,
                  color: appViewModel!.pageIndex.index == index ? Colors.black : GREY,
                ),
              ),
              if (count > 0)
                Container(
                  width: count > 10 ? 19.0 : 18.0,
                  height: count > 10 ? 19.0 : 18.0,
                  // width: count > 10 ? 19.0 : 18.0,
                  // height: count > 10 ? 19.0 : 18.0,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: RED.withOpacity(0.9)),
                  child: Center(
                    child: Text(
                      count > 10 ? '+10' : count.toString(),
                      style: TextStyle(
                        color: WHITE,
                        fontSize: count > 10 ? 8.0 : 10.0,
                        fontWeight: count > 10 ? FontWeight.w400 : FontWeight.bold,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
