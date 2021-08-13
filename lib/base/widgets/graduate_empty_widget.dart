import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:flutter/material.dart';

class GraduateEmptyWidget extends StatelessWidget {
  const GraduateEmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(context.translate('lbl_empty'));
  }
}
