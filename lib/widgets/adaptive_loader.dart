import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AdaptiveLoader extends StatelessWidget {
  final double size;
  final Color? color;

  const AdaptiveLoader({
    Key? key,
    this.size = 24.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if ((kIsWeb && _isMobileView(context)) ||
        (!kIsWeb && (Platform.isIOS || Platform.isMacOS))) {
      return SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator.adaptive(
          valueColor:
              color != null ? AlwaysStoppedAnimation<Color>(color!) : null,
        ),
      );
    } else {
      return SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor:
              color != null ? AlwaysStoppedAnimation<Color>(color!) : null,
        ),
      );
    }
  }

  bool _isMobileView(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < 600;
  }
}
