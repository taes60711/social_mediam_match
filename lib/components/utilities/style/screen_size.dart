// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class ScreenSize {
  static Size get _screenSize => WidgetsBinding.instance.window.physicalSize;
  static double get _pixelRatio => WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
  static double get topPadding => WidgetsBinding.instance.platformDispatcher.implicitView!.padding.top;
  static double get bottomPadding => WidgetsBinding.instance.platformDispatcher.implicitView!.padding.bottom;
  static double get width => _screenSize.width / _pixelRatio;
  static double get height => _screenSize.height / _pixelRatio;
  static double get safeHeight => height - topPadding;
  static double get safeWithBottonHeight => height - topPadding - bottomPadding;
}
