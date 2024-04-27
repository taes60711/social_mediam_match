// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class ScreenSize {
  Size screenSize = WidgetsBinding.instance.window.physicalSize;
  double pixelRatio = WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
  final safepadding = WidgetsBinding.instance.platformDispatcher.implicitView!.padding.top;
  double get width => screenSize.width / pixelRatio;
  double get height => screenSize.height / pixelRatio;
  double get safeheight => height - safepadding;
}
