import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/mobx/mobx_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/features/splash/viewmodels/splash_viewmodel.dart';

class GraduateIcon extends StatelessWidget {
  const GraduateIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SvgPicture.asset(
        //   'assets/icons/ic_char_logo.svg',
        //   fit: BoxFit.cover,
        //   height: context.fullHeight * 0.8,
        // ),
        Image.asset(
          'assets/icons/ic_logo.png',
          fit: BoxFit.cover,
          height: context.fullHeight * 0.9,
          // height: 100,
        ),
        // SvgPicture.asset(
        //   'assets/icons/ic_logo.svg',
        //   fit: BoxFit.cover,
        //   height: context.fullHeight * 0.8,
        // ),
      ],
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);

  static const String route = '/';

  static MaterialPageRoute get pageRoute => MaterialPageRoute(builder: (context) => const SplashPage());

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends MobxState<SplashPage, SplashViewmodel> {
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
      backgroundColor: WHITE,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            // Row(
            //   children: [
            //     Expanded(
            //       child: SvgPicture.asset(
            //         'assets/images/ic_logo.svg',
            //         fit: BoxFit.fitHeight,
            //       ),
            //     ),
            //   ],
            // ),

            const GraduateIcon(),

            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Copyright ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TEXT_COLOR,
                    fontSize: 14,
                    fontFamily: Theme.of(context).textTheme.headline1!.fontFamily,
                  ),
                ),
                const Icon(Icons.copyright, color: TEXT_COLOR),
                Text(
                  '2021 Damascus University FZLC',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TEXT_COLOR,
                    fontSize: 14,
                    fontFamily: Theme.of(context).textTheme.headline1!.fontFamily,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
