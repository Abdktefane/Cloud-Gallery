import 'package:flutter/material.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/base/ext/widget_ext.dart';
import 'package:graduation_project/base/widgets/overlay_builder.dart';

class MediaButtons extends StatefulWidget {
  const MediaButtons({
    Key? key,
    required this.onIconTapped,
    required this.icons,
  }) : super(key: key);

  final ValueChanged<int> onIconTapped;
  final List<IconData> icons;

  @override
  _MediaButtonsState createState() => _MediaButtonsState();
}

class _MediaButtonsState extends State<MediaButtons> with TickerProviderStateMixin {
  late final AnimationController _controller;

  int get iconsLength => widget.icons.length;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return BottomAbout(
          position: Offset(offset.dx, offset.dy - iconsLength * 35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(iconsLength, (int index) {
              return _buildChild(index);
            }).toList(),
          ).padding(padding: const EdgeInsets.only(top: 8.0)),
        );
      },
      child: IconButton(
        onPressed: toggleHideStatus,
        icon: const Icon(Icons.attach_file),
        color: ACCENT,
      ),
    );
  }

  Widget _buildChild(int index) {
    final Color backgroundColor = Theme.of(context).cardColor;
    // final Color foregroundColor = Theme.of(context).primaryColor;
    final Color foregroundColor = ACCENT.withAlpha(150);
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 1.0 - index / iconsLength / 2.0, curve: Curves.easeOut),
      ),
      child: FloatingActionButton(
        mini: true,
        child: Icon(widget.icons[index], color: foregroundColor),
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        onPressed: () => _onTapped(index),
      ).padding(padding: const EdgeInsets.all(4.0)),
    );
  }

  void toggleHideStatus() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onIconTapped(index);
  }
}
