import 'package:core_sdk/utils/constants.dart';
import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:core_sdk/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduation_project/app/app.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/app/viewmodels/app_viewmodel.dart';
import 'package:graduation_project/base/utils/validators.dart';
import 'package:graduation_project/base/widgets/graduate_gradient_button.dart';
import 'package:graduation_project/base/widgets/graduate_loader.dart';
import 'package:graduation_project/base/widgets/graduate_page_loader.dart';
import 'package:graduation_project/base/widgets/graduate_text_field.dart';
import 'package:graduation_project/features/login/viewmodels/login_viewmodel.dart';
import 'package:graduation_project/features/register/presentation/pages/register_page.dart';
import 'package:graduation_project/features/settings/presentation/pages/controll_panel_page.dart';
import 'package:graduation_project/features/splash/ui/pages/splash_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String route = '/login';

  static MaterialPageRoute get pageRoute => MaterialPageRoute(builder: (context) => const LoginPage());

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends MobxState<LoginPage, LoginViewmodel> {
  // final TextEditingController _userNameController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _userNameController = TextEditingController(text: 'test1@t.com');
  final TextEditingController _passwordController = TextEditingController(text: '123123');

  final _formKey = GlobalKey<FormState>();
  AppViewmodel? appViewmodel;

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
    super.didChangeDependencies();
    appViewmodel = Provider.of<AppViewmodel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return GraduateMobxPageLoader(
      viewmodel: viewmodel,
      child: Scaffold(
        key: viewmodel.scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false, //new line
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.fullWidth * 0.08),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 30,
                      bottom: 5,
                    ),
                    child: GraduateIcon(),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 40),
                  //   child: SvgPicture.asset('assets/images/slogan.svg'),
                  // ),
                  GraduateTextField(
                    context: context,
                    hintText: 'lbl_email',
                    validator: (value) => emailValidator(context: context, email: value ?? ''),
                    textEditingController: _userNameController,
                    // return emailValidator(context: context, email: value ?? '');
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 26,
                    ),
                    child: GraduateTextField(
                      textEditingController: _passwordController,
                      context: context,
                      hintText: 'lbl_password',
                      validator: (value) => passwordValidator(context: context, password: value ?? ''),

                      // return passwordValidator(context: context, password: value ?? '');
                      isSuffixIcon: true,
                      useObscure: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 25,
                    ),
                    child: GraduateGradientButton(
                      text: 'lbl_login',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          viewmodel.login(email: _userNameController.text, password: _passwordController.text);
                        }
                      },
                      context: context,
                    ),
                  ),
                  GraduateGradientButton(
                    context: context,
                    text: 'lbl_sign_up',
                    onPressed: () => context.pushNamed(RegisterPage.route),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.language,
                          color: DARK_GREY,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          context.translate('lbl_switch_language_to'),
                          style: textTheme?.bodyText1?.copyWith(color: DARK_GREY),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () {
                            appViewmodel?.changeLanguage(
                              isArabic(context: context) ? LANGUAGE_ENGLISH : LANGUAGE_ARABIC,
                            );
                          },
                          child: Text(
                            isArabic(localizations: context.locale) ? 'English' : 'العربية',
                            style: textTheme?.bodyText1!.copyWith(color: RED, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => App.navKey.currentContext?.pushPage(const ControllPanelPage()),
                    child: Text(
                      context.translate('lbl_control_panel'),
                      style: textTheme?.bodyText1!.copyWith(color: RED, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
