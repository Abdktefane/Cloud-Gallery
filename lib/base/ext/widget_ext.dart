import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  Widget expand({int flex = 1}) => Expanded(flex: flex, child: this);

  Widget asSingleChildScrollView({ScrollPhysics? physics}) => SingleChildScrollView(
        physics: physics,
        child: this,
      );

  Widget padding({required EdgeInsets padding}) => Padding(padding: padding, child: this);

  Widget modifier({
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip clipBehavior = Clip.none,
  }) =>
      Container(
        key: key,
        alignment: alignment,
        padding: padding,
        color: color,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        width: width,
        height: height,
        constraints: constraints,
        margin: margin,
        transform: transform,
        transformAlignment: transformAlignment,
        clipBehavior: clipBehavior,
        child: this,
      );
}
