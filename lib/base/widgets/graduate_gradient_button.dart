import 'package:core_sdk/utils/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:core_sdk/utils/extensions/build_context.dart';

class GraduateGradientButton extends StatelessWidget {
  const GraduateGradientButton({
    Key? key,
    this.text,
    this.onPressed,
    this.context,
    this.isLoading = false,
    this.enable = true,
  }) : super(key: key);

  final String? text;
  final Function? onPressed;
  final BuildContext? context;
  final bool isLoading;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.fullHeight * 0.07,
      child: RaisedButton(
        onPressed: (isLoading || !enable)
            ? null
            : () {
                FocusScope.of(context).unfocus();
                onPressed!();
              },
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: const EdgeInsets.all(0.0),
        child: Ink(
          decoration: (isLoading || !enable)
              ? null
              : const BoxDecoration(
                  gradient: BUTTON_GRADIENT,
                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                ),
          child: Container(
            constraints:
                const BoxConstraints(minWidth: double.infinity, minHeight: 55), // min sizes for Material buttons
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.translate(text!),
                  style: context.textTheme.bodyText1!.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                ProgressBar(visibility: isLoading, padding: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
