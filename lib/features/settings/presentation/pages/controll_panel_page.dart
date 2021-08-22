import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/extensions/mobx.dart';
import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:graduation_project/app/app.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/app/viewmodels/app_viewmodel.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:graduation_project/base/ext/widget_ext.dart';
import 'package:graduation_project/base/widgets/graduate_app_bar.dart';
import 'package:graduation_project/features/settings/presentation/widgets/setting_option_tile.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import 'package:get_it/get_it.dart';
import 'package:restart_app/restart_app.dart';

class ControllPanelPage extends StatefulWidget {
  const ControllPanelPage({
    Key? key,
  }) : super(key: key);

  @override
  _ControllPanelPageState createState() => _ControllPanelPageState();
}

class _ControllPanelPageState extends ProviderMobxState<ControllPanelPage, AppViewmodel> {
  final GraduateDB db = GetIt.I.get();
  final PrefsRepository prefsRepository = GetIt.I.get();

  String get baseUrl => prefsRepository.baseUrl ?? GetIt.I.get<String>(instanceName: 'ApiBaseUrl');
  ImageFileSource get imageFileSource => prefsRepository.imageFileSource;

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
      appBar: GraduateAppBar(title: context.translate('lbl_control_panel'), appViewModel: viewmodel),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingOption(
              title: context.translate('lbl_db_viewer'),
              icon: 'assets/icons/ic_language.png',
              isLoading: viewmodel?.logoutResult?.isPending ?? false,
              onTap: () {
                App.navKey.currentContext?.pushPage(MoorDbViewer(db));
              },
            ),
            TextFormField(
              initialValue: baseUrl,
              decoration: InputDecoration(labelText: context.translate('lbl_base_url')),
              onFieldSubmitted: (baseUrl) async {
                await prefsRepository.setBaseUrl(baseUrl);
                Restart.restartApp();
              },
            ).modifier(decoration: const BoxDecoration(color: WHITE)),
            Row(
              children: [
                DropdownButton(
                  hint: Text(context.translate('lbl_sync_folder')),
                  value: imageFileSource,
                  underline: const SizedBox(),
                  onChanged: (ImageFileSource? it) async {
                    await prefsRepository.setImageFileSource(it!);
                    setState(() {});
                  },
                  items: ImageFileSource.values
                      .map((it) => DropdownMenuItem(
                            value: it,
                            child: Text(context.translate(it.localizationKey)),
                          ))
                      .toList(),
                ),
              ],
            ).modifier(decoration: const BoxDecoration(color: WHITE)),
          ],
        ),
      ),
    );
  }
}
