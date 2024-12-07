import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

import 'style/style_config.dart';

class LoadingDialog {
  static final LoadingDialog _singleton = LoadingDialog._internal();

  factory LoadingDialog() {
    return _singleton;
  }

  late BuildContext _context;
  late OverlayEntry _overlayEntry;
  late OverlayState _overlay;

  LoadingDialog._internal();

  /// 在splash_screen 初始化
  void init(BuildContext context) {
    print("Loading畫面初始化, 畫面需要使用時 啟動：”LoadingDialog().show()”、關閉：”LoadingDialog().close()”");
    _context = context;
    _overlay = Overlay.of(_context);
  }

  void show({String loadingMsg = "Loading..."}) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: Center(
            child: Container(
              width: ScreenSize.fitPxWidth(200),
              height: ScreenSize.fitPxWidth(200),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(12)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.inkDrop(color: AppColors.orangeColor, size: 35),
                  SizedBox(height: ScreenSize.fitPxWidth(16)),
                  Text(
                    loadingMsg,
                    style: TextStyle(color: Colors.white, fontSize: ScreenSize.fontSize14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    _overlay.insert(_overlayEntry);
  }

  void close() {
    _overlayEntry.remove();
  }
}
