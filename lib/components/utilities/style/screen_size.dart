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

  static double fontSize12 = _fitFontSize(12);
  static double fontSize14 = _fitFontSize(14);
  static double fontSize16 = _fitFontSize(16);
  static double fontSize18 = _fitFontSize(18);
  static double fontSize20 = _fitFontSize(20);
  static double fontSize22 = _fitFontSize(22);
  static double fontSize24 = _fitFontSize(24);

  // 画面の幅に基づいて自動調整
  static double fitPxWidth(double size) {
    double normalWidth = 375;
    return size * (width / normalWidth);
  }

  // 画面の高さに基づいて自動調整
  static double fitPxHeight(double size) {
    double normalHeight = 750;
    return size * (height / normalHeight);
  }

  // 适配字体大小，支持14, 16, 18, 20, 22, 24
  static double _fitFontSize(double fontSize) {
    // 以设计稿中的基准宽度 (375px) 为依据
    double normalWidth = 375;
    // 根据当前屏幕宽度与设计稿宽度的比例来调整字体大小
    return fontSize * (width / normalWidth);
  }
}
