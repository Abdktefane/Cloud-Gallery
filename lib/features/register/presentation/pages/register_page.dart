import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/base/utils/validators.dart';
import 'package:graduation_project/base/widgets/graduate_gradient_button.dart';
import 'package:graduation_project/base/widgets/graduate_page_loader.dart';
import 'package:graduation_project/base/widgets/graduate_text_field.dart';
import 'package:graduation_project/features/register/presentation/viewmodels/register_viewmodel.dart';
import 'package:graduation_project/features/splash/ui/pages/splash_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static const String route = '/signUp';

  static MaterialPageRoute get pageRoute => MaterialPageRoute(builder: (context) => const RegisterPage());

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends MobxState<RegisterPage, RegisterViewmodel> {
  // final TextEditingController _confirmPasswordController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _emailController = TextEditingController(text: 'test2@t.com');
  final TextEditingController _passwordController = TextEditingController(text: '123123');
  final TextEditingController _confirmPasswordController = TextEditingController(text: '123123');

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: viewmodel.scaffoldKey,
      backgroundColor: WHITE,
      body: GraduateMobxPageLoader(
        viewmodel: viewmodel,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.fullWidth * 0.08),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 30,
                      bottom: 5,
                    ),
                    child: GraduateIcon(),
                  ),
                  GraduateTextField(
                    context: context,
                    hintText: 'lbl_email',
                    validator: (value) => emailValidator(context: context, email: value ?? ''),
                    textEditingController: _emailController,
                  ),
                  const SizedBox(height: 45.0),
                  GraduateTextField(
                    context: context,
                    hintText: 'lbl_password',
                    textEditingController: _passwordController,
                    isSuffixIcon: true,
                    useObscure: true,
                    validator: (value) => passwordValidator(context: context, password: value ?? ''),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 45, bottom: 45),
                    child: GraduateTextField(
                      context: context,
                      hintText: 'lbl_confirm_password',
                      textEditingController: _confirmPasswordController,
                      isSuffixIcon: true,
                      useObscure: true,
                      validator: (value) => confirmPasswordValidator(
                          password: _passwordController.text, context: context, confirmPassword: value),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  GraduateGradientButton(
                    context: context,
                    text: 'lbl_sign_up',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        viewmodel.register(email: _emailController.text, password: _passwordController.text);
                      }
                    },
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
