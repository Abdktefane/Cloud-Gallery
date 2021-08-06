import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduation_project/app/theme/colors.dart';

class GraduateLoader extends StatelessWidget {
  const GraduateLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        SpinKitThreeBounce(color: PRIMARY, size: 24.0),
      ],
    );
  }
}
