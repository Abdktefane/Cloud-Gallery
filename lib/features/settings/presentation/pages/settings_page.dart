import 'package:core_sdk/utils/dialogs.dart';
import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/extensions/mobx.dart';
import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:graduation_project/app/app.dart';
import 'package:graduation_project/app/viewmodels/app_viewmodel.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/widgets/graduate_app_bar.dart';
import 'package:graduation_project/features/login/ui/pages/login_page.dart';
import 'package:graduation_project/features/settings/presentation/pages/change_language.dart';
import 'package:graduation_project/features/settings/presentation/pages/controll_panel_page.dart';
import 'package:graduation_project/features/settings/presentation/widgets/setting_option_tile.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends ProviderMobxState<SettingsPage, AppViewmodel> {
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
      appBar: GraduateAppBar(title: context.translate('lbl_settings'), appViewModel: viewmodel),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingOption(
              title: context.translate('lbl_language'),
              icon: 'assets/icons/ic_language.png',
              onTap: () {
                _navigateTo(const ChangeLanguage());
              },
            ),
            // if (kDebugMode)
            SettingOption(
              title: context.translate('lbl_control_panel'),
              icon: 'assets/icons/ic_language.png',
              onTap: () => App.navKey.currentContext?.pushPage(const ControllPanelPage()),
            ),
            // if (kDebugMode)

            Observer(builder: (_) {
              return SettingOption(
                title: context.translate('lbl_logout'),
                icon: 'assets/icons/ic_logout.png',
                isLoading: viewmodel?.logoutResult?.isPending ?? false,
                onTap: () {
                  showConfirmDialog(
                    context,
                    context.translate('msg_app_exit_confirm'),
                    () => viewmodel?.logout(onSuccess: () {
                      App.navKey.currentState!.pushNamedAndRemoveUntil(LoginPage.route, (_) => false);
                    }),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateTo(Widget page) async {
    final backToHome = await context.cupertinoPushPage(page);
    if (backToHome as bool? ?? false) {
      viewmodel?.navigateTo(PageIndex.home);
    }
  }
}
