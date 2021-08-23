import 'dart:io';

import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:graduation_project/app/base_page.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:graduation_project/features/backup/data/stores/backup_store.dart';
import 'package:graduation_project/features/backup/data/stores/tokens_store.dart';
import 'package:graduation_project/features/login/ui/pages/login_page.dart';
import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:core_sdk/utils/extensions/string.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supercharged/supercharged.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get_it/get_it.dart';

part 'splash_viewmodel.g.dart';

@injectable
class SplashViewmodel extends _SplashViewmodelBase with _$SplashViewmodel {
  SplashViewmodel(
    Logger logger,
    TokensStore _tokensStore,
  ) : super(logger, _tokensStore);
}

abstract class _SplashViewmodelBase extends BaseViewmodel with Store {
  _SplashViewmodelBase(Logger logger, this._tokensStore) : super(logger) {
    Future.delayed(
      2.seconds,
      () => getContext((context) async {
        // context.pushNamedAndRemoveUntil(BasePage.route, (_) => false);
        await _store.moveUploadingToPending();
        if (await Permission.storage.request().isGranted) {
          // final path = await getExternalStorageDirectories(type: StorageDirectory.pictures);
          // final directory = Directory(path!.first.path + '/' + kSyncFolderName);
          final path = 'storage/emulated/0/Android/media/$kSyncFolderName';
          final directory = Directory(path);
          if (!directory.existsSync()) {
            await directory.create(recursive: true);
          }
        }
        final token = (await _tokensStore.getToken())?.token;
        token.isNullOrEmpty
            ? context.pushNamedAndRemoveUntil(LoginPage.route, (_) => false)
            : context.pushNamedAndRemoveUntil(BasePage.route, (_) => false);
      }),
    );
  }
  final TokensStore _tokensStore;
  final BackupsStore _store = GetIt.I();

  //* OBSERVERS *//

  //* COMPUTED *//

  //* ACTIONS *//

}
