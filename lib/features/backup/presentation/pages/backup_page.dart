import 'package:core_sdk/utils/pagination_mixin.dart';
import 'package:core_sdk/utils/widgets/pagination_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/extensions/mobx.dart';
import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/base/widgets/graduate_loader.dart';
import 'package:graduation_project/features/backup/presentation/viewmodels/backup_image_ui_model.dart';
import 'package:graduation_project/features/backup/presentation/viewmodels/backup_viewmodel.dart';
import 'package:graduation_project/features/backup/presentation/widgets/backup_image_tile.dart';

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
  @override
  void initState() {
    super.initState();
    initPagination();
  }

  @override
  void dispose() {
    disposePagination();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          return PaginationList<BackupImageUIModel>(
            loadingWidget: const Center(child: GraduateLoader()),
            dataList: viewmodel.images!,
            emptyWidget: const Text('no result'),
            // TODO(abd): find way to handle loadmore
            canLoadMore: viewmodel.images?.length != 1000,
            scrollController: scrollController,
            cardBuilder: (it) => BackupImageTile(model: it),
          );
        },
      ),
    );
  }

  @override
  void onLoadMore() => viewmodel.fetchLocalImages();
}
