import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/app/viewmodels/app_viewmodel.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/ext/widget_ext.dart';
import 'package:graduation_project/base/widgets/graduate_loader.dart';
import 'package:graduation_project/features/backup/presentation/viewmodels/backup_viewmodel.dart';
import 'package:graduation_project/features/backup/presentation/widgets/backup_tile.dart';
import 'package:graduation_project/features/backup/presentation/widgets/strream_observer.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({
    Key? key,
  }) : super(key: key);

  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  static MaterialPageRoute get pageRoute => MaterialPageRoute(builder: (context) => const BackupPage());

  @override
  _BackupPageState createState() => _BackupPageState();
}

class _BackupPageState extends MobxState<BackupPage, BackupViewmodel> {
  AppViewmodel? _appViewmodel;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _appViewmodel = Provider.of<AppViewmodel>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Observer(
      builder: (_) {
        return _appViewmodel?.imageSyncing == true
            ? const Center(child: GraduateLoader())
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Observer(builder: (_) {
                        return DropdownButton(
                          value: viewmodel.filter,
                          items: BackupStatus.values
                              .map((it) => DropdownMenuItem(
                                    value: it,
                                    child: Text(describeEnum(it).toLowerCase()),
                                    // onTap: () => viewmodel.changeFilter(it),
                                  ))
                              .toList(),
                          onChanged: (BackupStatus? it) => viewmodel.changeFilter(it!),
                        );
                      })
                    ],
                  ),
                  StreamObserver<List<Backup>>(
                    stream: viewmodel.images,
                    onSuccess: (images) => ListView.builder(
                      padding: const EdgeInsets.only(top: 8.0),
                      itemCount: images.length,
                      itemBuilder: (_, index) => BackupTile(backup: images[index]),
                    ),
                  ).expand(),
                ],
              );
      },
    ));
  }
}
