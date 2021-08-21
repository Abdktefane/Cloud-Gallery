import 'dart:async';

import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:core_sdk/utils/pagination_mixin.dart';
import 'package:core_sdk/utils/search_mixin.dart';
import 'package:core_sdk/utils/widgets/pagination_list.dart';
import 'package:core_sdk/utils/widgets/staggered_column.dart';
import 'package:core_sdk/utils/widgets/staggered_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/app/viewmodels/app_viewmodel.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/models/pagination_response.dart';
import 'package:graduation_project/base/data/models/search_result_model.dart';
import 'package:graduation_project/base/ext/widget_ext.dart';
import 'package:graduation_project/base/utils/image_url_provider.dart';
import 'package:graduation_project/base/widgets/graduate_empty_widget.dart';
import 'package:graduation_project/base/widgets/graduate_page_loader.dart';
import 'package:graduation_project/base/widgets/graduate_stream_observer.dart';
import 'package:graduation_project/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:graduation_project/features/home/presentation/widgets/image_tile.dart';
import 'package:graduation_project/features/home/presentation/widgets/media_buttons.dart';
import 'package:supercharged/supercharged.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

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

  @override
  void initState() {
    super.initState();
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
          // key: viewmodel.scaffoldKey,
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
    return GraduateStreamObserver<PaginationResponse<SearchResultModel>>(
      stream: viewmodel.searchResult!,
      onSuccess: (results) => StaggredPaginationList<SearchResultModel>(
        key: ValueKey(results.hashCode),
        padding: 8.0,
        shrinkWrap: false,
        dataList: results.data!,
        canLoadMore: false,
        staggeredAnimations: const [StaggeredType.SlideAnimation],
        scrollController: scrollController,
        emptyWidget: const GraduateEmptyWidget(),
        cardBuilder: (image) => ImageTile(imageUrlProvider: _imageUrlProvider, serverPath: image.data!),
        // cardBuilder: (image) => Text(image.id.toString()),
      ),
    );
  }

  @override
  void onLoadMore() => viewmodel.search();

  @override
  void onSearch(String qurey) => viewmodel.searchByText(qurey);
}
