import 'package:flutter/material.dart';

class AnchoredOverlay extends StatelessWidget {
  const AnchoredOverlay({
    Key? key,
    required this.showOverlay,
    required this.overlayBuilder,
    required this.child,
  }) : super(key: key);
  final bool showOverlay;
  final Widget Function(BuildContext, Offset anchor) overlayBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return OverlayBuilder(
          showOverlay: showOverlay,
          overlayBuilder: (BuildContext overlayContext) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final center = box.size.center(box.localToGlobal(const Offset(0.0, 0.0)));
            return overlayBuilder(overlayContext, center);
          },
          child: child,
        );
      }),
    );
  }
}

class OverlayBuilder extends StatefulWidget {
  const OverlayBuilder({
    Key? key,
    this.showOverlay = false,
    required this.overlayBuilder,
    required this.child,
  }) : super(key: key);
  final bool showOverlay;
  final Widget Function(BuildContext) overlayBuilder;
  final Widget child;

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder> {
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.showOverlay) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => showOverlay());
    }
  }

  @override
  void didUpdateWidget(OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance?.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance?.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void dispose() {
    if (isShowingOverlay()) {
      hideOverlay();
    }

    super.dispose();
  }

  bool isShowingOverlay() => overlayEntry != null;

  void showOverlay() {
    overlayEntry = OverlayEntry(
      builder: widget.overlayBuilder,
    );
    addToOverlay(overlayEntry!);
  }

  Future<void> addToOverlay(OverlayEntry entry) async {
    print('addToOverlay');
    Overlay.of(context)?.insert(entry);
  }

  void hideOverlay() {
    print('hideOverlay');
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void syncWidgetAndOverlay() {
    if (isShowingOverlay() && !widget.showOverlay) {
      hideOverlay();
    } else if (!isShowingOverlay() && widget.showOverlay) {
      showOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class CenterAbout extends StatelessWidget {
  const CenterAbout({
    Key? key,
    required this.position,
    required this.child,
  }) : super(key: key);

  final Offset position;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.dy,
      left: position.dx,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: child,
      ),
    );
  }
}

class BottomAbout extends StatelessWidget {
  const BottomAbout({
    Key? key,
    required this.position,
    required this.child,
  }) : super(key: key);

  final Offset position;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.dy,
      left: position.dx,
      child: FractionalTranslation(
        translation: const Offset(-0.5, 0),
        child: child,
      ),
    );
  }
}
