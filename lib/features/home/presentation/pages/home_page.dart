import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:core_sdk/utils/pagination_mixin.dart';
import 'package:core_sdk/utils/search_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/ext/widget_ext.dart';
import 'package:graduation_project/base/widgets/graduate_page_loader.dart';
import 'package:graduation_project/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:graduation_project/features/home/presentation/widgets/media_buttons.dart';
import 'package:supercharged/supercharged.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  static MaterialPageRoute get pageRoute => MaterialPageRoute(builder: (context) => const HomePage());

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends MobxState<HomePage, HomeViewmodel> with SearchMixin, PaginationMixin {
  @override
  void initState() {
    super.initState();
    initSearch();
    initPagination();
  }

  @override
  void dispose() {
    disposeSearch();
    disposePagination();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GraduateMobxPageLoader(
        viewmodel: viewmodel,
        child: Scaffold(
          key: viewmodel.scaffoldKey,
          body: Column(
            children: [
              searchWidget(),
              searchResult().expand(),
            ],
          ),
        ));
  }

  Widget searchWidget() {
    return Row(
      children: [
        TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            isCollapsed: true,
            hintText: context.translate('lbl_search'),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            border: InputBorder.none,
          ),
          // expands: true,
        ).expand(),
        MediaButtons(
          icons: const [Icons.camera, Icons.image],
          onIconTapped: (index) async => viewmodel.searchByImage(index),
        ),
        filterWidget(),
      ],
    ).modifier(
      decoration: BoxDecoration(color: WHITE, border: Border.all(color: Colors.black26, width: 0.5)),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
    );
  }

  Widget filterWidget() {
    return Observer(
      builder: (_) {
        return AnimatedSwitcher(
          duration: 400.milliseconds,
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: viewmodel.imageSource.getIcon(viewmodel.toggleImageSource, color: ACCENT.withAlpha(150)),
        );
      },
    );
  }

  bool showMediaOptions = false;

  Widget searchResult() {
    return ListView(children: const []);
  }

  @override
  void onLoadMore() {
    // TODO(abd): finde way to know what source is image or text
  }

  @override
  void onSearch(String qurey) => viewmodel.searchByText(qurey);
}
