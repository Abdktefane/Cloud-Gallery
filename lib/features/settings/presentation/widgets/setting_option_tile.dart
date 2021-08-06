import 'package:core_sdk/utils/utils.dart';
import 'package:core_sdk/utils/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/app/theme/colors.dart';

class SettingOption extends StatelessWidget {
  const SettingOption({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isLoading = false,
    this.activeColor = TEXT_COLOR,
    this.backButtonColor,
    Key? key,
  }) : super(key: key);

  final String? title;
  final String? icon;
  final bool isLoading;
  final VoidCallback? onTap;
  final Color activeColor;
  final Color? backButtonColor;

  bool get isVerified => onTap != null;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: isVerified ? onTap : () {},
      color: WHITE,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: LIGHT_GREY),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17.0),
        child: Row(
          children: [
            if (icon != null)
              Image.asset(
                icon!,
                width: 24.0,
                height: 24.0,
                color: isVerified ? ACCENT : LIGHT_GREY,
              ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                title!,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: isVerified ? activeColor : GREY,
                    ),
              ),
            ),
            if (isLoading)
              ProgressBar(color: PRIMARY)
            else
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: backButtonColor ?? (isVerified ? DARK_GREY : GREY),
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
