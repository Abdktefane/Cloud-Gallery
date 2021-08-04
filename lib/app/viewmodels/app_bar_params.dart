import 'package:core_sdk/utils/colors.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// TODO(abd):  move this to core_sdk
class AppBarParams extends Equatable {
  const AppBarParams({
    required this.title,
    required this.onBackPressed,
    this.backgroundColor = WHITE,
    this.showNotificationIcon = true,
    this.showBackButton = false,
    this.translateTitle = true,
    this.bottom,
  });

  final String title;
  final Color backgroundColor;
  final bool showNotificationIcon;
  final bool showBackButton;
  final bool translateTitle;
  final VoidCallback? onBackPressed;
  final PreferredSizeWidget? bottom;

  static AppBarParams initial(bool isPlayer) {
    return AppBarParams(
      title: 'lbl_home',
      onBackPressed: null,
    );
  }

  AppBarParams copyWith({
    String? title,
    Color? backgroundColor,
    bool? showNotificationIcon,
    bool? showBackButton,
    bool? translateTitle,
    VoidCallback? onBackPressed,
    PreferredSizeWidget? bottom,
  }) {
    return AppBarParams(
      title: title ?? this.title,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      showNotificationIcon: showNotificationIcon ?? this.showNotificationIcon,
      showBackButton: showBackButton ?? this.showBackButton,
      translateTitle: translateTitle ?? this.translateTitle,
      onBackPressed: onBackPressed ?? this.onBackPressed,
      bottom: bottom ?? this.bottom,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      title,
      backgroundColor,
      showNotificationIcon,
      showBackButton,
      translateTitle,
      onBackPressed,
      bottom,
    ];
  }
}
