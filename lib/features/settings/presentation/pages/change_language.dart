import 'package:core_sdk/utils/constants.dart';
import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/widgets/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/app/viewmodels/app_viewmodel.dart';
import 'package:graduation_project/base/widgets/graduate_page_loader.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({Key? key}) : super(key: key);

  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  String? language;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    language = context.locale!.locale.languageCode;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      // appBar: widget.showAppBar
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: WHITE,
        automaticallyImplyLeading: false,
        leading: const CupertinoNavigationBarBackButton(color: TEXT_COLOR),
        title: Text(
          context.translate('lbl_change_language'),
          style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 18),
        ),
        elevation: 0.0,
      ),
      body: Observer(builder: (_) {
        return GraduatePageLoader(
          isLoading: Provider.of<AppViewmodel>(context, listen: false).languageLoading,
          child: Column(
            children: [
              const SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    languageTile(
                      code: LANGUAGE_ARABIC,
                      name: 'العربية',
                      isLoading: false,
                    ),
                    languageTile(
                      code: LANGUAGE_ENGLISH,
                      name: 'English',
                      isLoading: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget languageTile({
    required String code,
    required String name,
    required bool isLoading,
  }) {
    final isSelected = code == language;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FlatButton(
          onPressed: () => Provider.of<AppViewmodel>(context, listen: false).changeLanguage(code),
          color: WHITE,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              width: 1.0,
              color: isSelected ? ACCENT : GREY,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: textStyle!.copyWith(fontSize: 16, color: isSelected ? ACCENT : DARK_GREY),
              ),
              Visibility(
                visible: isLoading && !isSelected,
                child: ProgressBar(
                  visibility: isLoading,
                  padding: 8.0,
                  color: ACCENT,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle? get textStyle => Theme.of(context).textTheme.bodyText1;
}
