import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:core_sdk/utils/widgets/staggered_column.dart';
import 'package:core_sdk/utils/widgets/staggered_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/app/viewmodels/app_viewmodel.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:graduation_project/base/ext/widget_ext.dart';
import 'package:graduation_project/base/utils/image_url_provider.dart';
import 'package:graduation_project/base/widgets/graduate_empty_widget.dart';
import 'package:graduation_project/base/widgets/graduate_stream_observer.dart';
import 'package:graduation_project/features/backup/presentation/viewmodels/backup_viewmodel.dart';
import 'package:graduation_project/features/backup/presentation/widgets/backup_tile.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({
    Key? key,
  }) : super(key: key);

  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  static MaterialPageRoute get pageRoute => MaterialPageRoute(builder: (context) => const BackupPage());

  @override
  _BackupPageState createState() => _BackupPageState();
}

class _BackupPageState extends MobxState<BackupPage, BackupViewmodel> with PaginationMixin {
  AppViewmodel? _appViewmodel;
  final ImageUrlProvider _imageUrlProvider = GetIt.I();
  final PrefsRepository _prefsRepository = GetIt.I();

  @override
  void initState() {
    initPagination();
    super.initState();
  }

  @override
  void dispose() {
    disposePagination();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _appViewmodel = Provider.of<AppViewmodel>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: viewmodel.scaffoldKey,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _imagesCountBuilder(),
              _filterBuilder(),
              _modifierBuilder(),
            ],
          ),
          const SizedBox(height: 8.0),
          GraduateStreamObserver<List<Backup>?>(
            stream: viewmodel.images!,
            onSuccess: (images) => StaggredPaginationList<Backup>(
              key: ValueKey(viewmodel.filter.hashCode),
              padding: 8.0,
              shrinkWrap: false,
              dataList: images!,
              canLoadMore: false,
              staggeredAnimations: const [StaggeredType.SlideAnimation],
              scrollController: scrollController,
              duration: 250.milliseconds,
              emptyWidget: const GraduateEmptyWidget(),
              cardBuilder: (image) => BackupTile(
                backup: image,
                imageUrlProvider: _imageUrlProvider,
                token: _prefsRepository.token ?? '',
                restoreImage: () => viewmodel.restoreImage(image),
                toggleModifier: (_) => viewmodel.toggleBackupModifire(image),
                searchByImage: (_) {
                  _appViewmodel?.serverPath = image.serverPath!;
                  _appViewmodel?.navigateTo(PageIndex.home);
                },
              ),
            ),
          ).expand(),
        ],
      ),
    ).asMobxPageLoader(viewmodel);
  }

  Widget _imagesCountBuilder() {
    return GraduateStreamObserver<int>(
      stream: viewmodel.imagesCount!,
      onSuccess: (count) => Text(
        context.translate('lbl_total_images') + ': ' + count.toString(),
        style: textTheme?.bodyText1?.copyWith(color: ACCENT),
      ).padding(padding: const EdgeInsets.symmetric(horizontal: 18.0)),
    );
  }

  Widget _filterBuilder() {
    return Observer(builder: (_) {
      return DropdownButton<BackupStatusUi>(
        value: viewmodel.filter,
        underline: const SizedBox(),
        onChanged: (BackupStatusUi? it) => viewmodel.changeFilter(it!),
        items: BackupStatusUi.values
            .where((it) => it != BackupStatusUi.UPLOADING)
            .map((it) => DropdownMenuItem(
                  value: it,
                  child: Text(context.translate(it.localizationKey)),
                ))
            .toList(),
      );
    });
  }

  Widget _modifierBuilder() {
    return Observer(
      builder: (_) {
        return AnimatedSwitcher(
          duration: 400.milliseconds,
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: viewmodel.filter == BackupStatusUi.UPLOADED
              ? viewmodel.modifier.getIcon(viewmodel.toggleFilterModifer, color: ACCENT.withAlpha(150))
              : const SizedBox(width: 48, height: 48),
        );
      },
    );
  }

  @override
  void onLoadMore() => viewmodel.loadMore();
}

mixin PaginationMixin {
  late ScrollController scrollController;
  late double percent;
  int lastNumberOfPages = 0;

  void initPagination({double percent = 0.7}) {
    scrollController = ScrollController()..addListener(_handleScrollListner);
    this.percent = percent;
  }

  void disposePagination() {
    scrollController.dispose();
  }

  void _handleScrollListner() {
    scrollController.position.pixels;

    final double max = scrollController.position.maxScrollExtent;
    final double viewport = scrollController.position.viewportDimension / 2;
    final double before = scrollController.position.extentBefore;
    final int numberOfPages = (max / viewport).round();
    if (before > (max * percent) && !scrollController.position.outOfRange && lastNumberOfPages != numberOfPages) {
      lastNumberOfPages = numberOfPages;
      onLoadMore();
    }
  }

  void onLoadMore();
}
