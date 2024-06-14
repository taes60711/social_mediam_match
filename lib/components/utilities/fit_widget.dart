import 'package:flutter/material.dart';

class FitWidget extends StatelessWidget {
  final double height;
  final Widget child;
  final Alignment alignment;
  const FitWidget({
    super.key,
    required this.child,
    required this.height,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: FittedBox(
        alignment: alignment,
        child: child,
      ),
    );
  }
}
