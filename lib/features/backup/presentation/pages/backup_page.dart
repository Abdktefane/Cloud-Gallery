import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:core_sdk/utils/pagination_mixin.dart';
import 'package:core_sdk/utils/widgets/pagination_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/app/viewmodels/app_viewmodel.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/ext/widget_ext.dart';
import 'package:graduation_project/base/widgets/graduate_empty_widget.dart';
import 'package:graduation_project/base/widgets/graduate_loader.dart';
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
            onSuccess: (images) => PaginationList<Backup>(
              padding: 8.0,
              shrinkWrap: false,
              dataList: images!,
              canLoadMore: false,
              scrollController: scrollController,
              emptyWidget: const GraduateEmptyWidget(),
              cardBuilder: (image) => BackupTile(backup: image),
            ),
          ).expand(),
        ],
      ),
    );
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
      return DropdownButton(
        value: viewmodel.filter,
        underline: const SizedBox(),
        onChanged: (BackupStatus? it) => viewmodel.changeFilter(it!),
        items: BackupStatus.values
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
          child: viewmodel.filter == BackupStatus.UPLOADED
              ? viewmodel.modifier.getIcon(viewmodel.toggleModifer, color: ACCENT.withAlpha(150))
              : const SizedBox(width: 48, height: 48),
        );
      },
    );
  }

  @override
  void onLoadMore() => viewmodel.loadMore();
}
