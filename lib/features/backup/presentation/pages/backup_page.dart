import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/features/backup/presentation/viewmodels/backup_viewmodel.dart';
import 'package:graduation_project/features/backup/presentation/widgets/backup_tile.dart';
import 'package:graduation_project/features/backup/presentation/widgets/strream_observer.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamObserver<List<Backup>>(
        stream: viewmodel.images,
        onSuccess: (images) => ListView.builder(
          padding: const EdgeInsets.only(top: 8.0),
          itemCount: images.length,
          itemBuilder: (_, index) => BackupTile(backup: images[index]),
        ),
      ),
    );
  }
}
