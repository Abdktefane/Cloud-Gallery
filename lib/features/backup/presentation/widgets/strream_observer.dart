import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class StreamObserver<T> extends StatelessWidget {
  const StreamObserver({
    Key? key,
    required this.stream,
    required this.onSuccess,
    this.emptyWidget = const Center(child: CircularProgressIndicator()),
  }) : super(key: key);
  final ObservableStream<T>? stream;
  final Widget emptyWidget;
  final Widget Function(T) onSuccess;

  @override
  Widget build(BuildContext context) {
    if (stream == null) {
      return Container();
    }
    return Observer(
      builder: (_) {
        switch (stream?.value) {
          case null:
            return emptyWidget;
          default:
            return onSuccess(stream!.value!);
        }
      },
    );
  }
}
