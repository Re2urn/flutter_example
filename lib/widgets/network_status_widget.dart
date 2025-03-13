import 'package:flutter/material.dart';

class NetworkStatusWidget extends StatelessWidget {
  final Widget child;
  final Widget offlineWidget;
  final bool isOffline;

  const NetworkStatusWidget({
    Key? key,
    required this.child,
    required this.offlineWidget,
    required this.isOffline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isOffline) offlineWidget,
      ],
    );
  }
}
