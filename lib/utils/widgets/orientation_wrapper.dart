import 'package:flutter/material.dart';

class OrientationWrapper extends StatelessWidget {
  final Widget portraitMode;
  final Widget landscapeMode;

  const OrientationWrapper({
    super.key,
    required this.portraitMode,
    required this.landscapeMode,
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 600) {
      // Use layout for smaller screens
      return portraitMode;
    } else {
      // Use layout for larger screens
      return landscapeMode;
    }
  }
}
