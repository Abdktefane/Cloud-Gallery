import 'dart:async';

import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:core_sdk/utils/pagination_mixin.dart';
import 'package:core_sdk/utils/search_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_it/get_it.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/app/viewmodels/app_viewmodel.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/models/search_result_model.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:graduation_project/base/ext/widget_ext.dart';
import 'package:graduation_project/base/utils/image_url_provider.dart';
import 'package:graduation_project/base/widgets/graduate_page_loader.dart';
import 'package:graduation_project/base/widgets/graduate_stream_observer.dart';
import 'package:graduation_project/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:graduation_project/features/home/presentation/widgets/image_tile.dart';
import 'package:graduation_project/features/home/presentation/widgets/media_buttons.dart';
import 'package:provider/provider.dart';
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
  late final AppViewmodel _appViewmodel;
  final ImageUrlProvider _imageUrlProvider = GetIt.I();
  final PrefsRepository _prefsRepository = GetIt.I();

  late final String token;

  @override
  void initState() {
    super.initState();
    token = _prefsRepository.token ?? '';
    initSearch();
    initPagination();
    scheduleMicrotask(() {
      _appViewmodel = Provider.of<AppViewmodel>(context, listen: false);
      if (_appViewmodel.serverPath != null) {
        viewmodel.searchBySimiliraty(_appViewmodel.serverPath!);
        _appViewmodel.serverPath = null;
      }
    });
  }

  @override
  void dispose() {
    disposeSearch();
    disposePagination();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GraduateMobxPageLoader(
      viewmodel: viewmodel,
      child: Scaffold(
        key: viewmodel.scaffoldKey,
        backgroundColor: WHITE,
        body: Column(
          children: [
            searchWidget(),
            searchResult().expand(),
          ],
        ),
      ),
    );
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
            // suffixIcon: AnimatedSwitcher(
            //   duration: const Duration(milliseconds: 150),
            //   child: searchController?.text.isNullOrEmpty == false
            //       ? Container(
            //           padding: const EdgeInsets.all(2.0),
            //           decoration: const BoxDecoration(shape: BoxShape.circle, color: GREY),
            //           child: IconButton(
            //             padding: EdgeInsets.zero,
            //             constraints: const BoxConstraints(),
            //             icon: const Icon(Icons.close_rounded, color: WHITE),
            //             iconSize: 16.0,
            //             onPressed: () {
            //               searchController?.clear();
            //               viewmodel.clearSearch(text: true);
            //             },
            //           ),
            //         )
            //       : const SizedBox(),
            // ),
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
      decoration: BoxDecoration(color: OFF_WHITE, borderRadius: BorderRadius.circular(18.0)),
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
    return Stack(
      children: [
        Observer(
          builder: (_) => GraduateListObserver<SearchResultModel>(
            list: viewmodel.searchResult,
            onSuccess: (images) => Container(
              key: viewmodel.listKey,
              child: AnimationLimiter(
                child: StaggeredGridView.countBuilder(
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  itemCount: images.length,
                  controller: scrollController,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  staggeredTileBuilder: (index) => StaggeredTile.count(1, index.isEven ? 1 : 1.4),
                  itemBuilder: (BuildContext context, int index) => AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    columnCount: 2,
                    child: ScaleAnimation(
                      scale: 0.5,
                      child: FadeInAnimation(
                        child: ImageTile(
                          imageUrlProvider: _imageUrlProvider,
                          serverPath: images[index].data!,
                          token: token,
                          searchByImage: (id) => viewmodel.searchBySimiliraty(id),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ).padding(padding: const EdgeInsets.symmetric(horizontal: 4.0)),
        ),
        Container(
          decoration: const BoxDecoration(color: Colors.black26 /* , borderRadius: BorderRadius.circular(18.0) */),
          width: context.fullWidth,
          child: appliedFilter(),
        ),
      ],
    );
  }

  Widget appliedFilter() {
    return Observer(
      builder: (_) {
        late final Widget child;
        if (viewmodel.textMode)
          child = AppliedFilter(
            key: const ValueKey('lbl_text_search'),
            title: 'lbl_text_search',
            onDelete: () {
              searchController?.clear();
              viewmodel.clearSearch(text: true);
            },
          );
        else if (viewmodel.imageMode)
          child = AppliedFilter(
            key: const ValueKey('lbl_image_search'),
            title: 'lbl_image_search',
            onDelete: () => viewmodel.clearSearch(image: true),
          );
        else if (viewmodel.simMode)
          child = AppliedFilter(
            key: const ValueKey('lbl_sim_search'),
            title: 'lbl_sim_search',
            onDelete: () => viewmodel.clearSearch(sim: true),
          );
        else
          child = const AppliedFilter(key: ValueKey('lbl_recommendations'), title: 'lbl_recommendations');
        // else if (viewmodel.simMode) child = const AppliedFilter(title: 'lbl_recommendations');
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [AnimatedSwitcher(duration: 250.milliseconds, child: child)],
        ).padding(padding: const EdgeInsets.symmetric(horizontal: 14.0));
      },
    );
  }

  @override
  void onLoadMore() => viewmodel.search();

  @override
  void onSearch(String qurey) {
    if (qurey.isNotEmpty) {
      viewmodel.searchByText(qurey);
    }
  }
}

class AppliedFilter extends StatelessWidget {
  const AppliedFilter({
    Key? key,
    required this.title,
    this.onDelete,
  }) : super(key: key);

  final String title;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: ACCENT.withAlpha(200),
      onDeleted: onDelete,
      deleteIconColor: WHITE,
      label: Text(context.translate(title), style: context.textTheme.bodyText1?.copyWith(color: WHITE)),
    );
  }
}
