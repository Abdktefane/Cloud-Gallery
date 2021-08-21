import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/app/viewmodels/app_viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:supercharged/supercharged.dart';

class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({Key? key, required this.viewmodel}) : super(key: key);

  final AppViewmodel viewmodel;

  double get height => 36.0;
  double get width => 36.0;

  Color get iconColor => PRIMARY;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        late final Widget child;

        if (viewmodel.imageSaving) {
          child = _buildSavingIndecator(context, true);
        } else if (viewmodel.imageUploading) {
          child = _buildUploadingIndecator();
        } else {
          child = _buildSavingIndecator(context, false);
        }

        return AnimatedSwitcher(duration: 250.milliseconds, child: child);
      },
    );
  }

  Widget _buildSavingIndecator(BuildContext context, bool isSaving) {
    return GestureDetector(
      onTap: viewmodel.saveImages,
      child: Lottie.asset('assets/animations/files_sync.json', width: width, height: height, animate: isSaving),
    );
  }

  Widget _buildUploadingIndecator() {
    return Lottie.asset('assets/animations/cloud_sync.json', width: width, height: height);
  }
}
