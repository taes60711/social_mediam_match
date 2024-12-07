import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

class Toast {
  static final Toast _singleton = Toast._internal();

  factory Toast() {
    return _singleton;
  }

  late BuildContext _context;
  late OverlayEntry _overlayEntry;
  late OverlayState _overlay;

  Toast._internal();

  /// 在splash_screen 初始化
  void init(BuildContext context) {
    print("Toast畫面初始化, 畫面需要使用時 啟動：”Toast().show()”、關閉：”Toast().close()”");
    _context = context;
    _overlay = Overlay.of(_context);
  }

  void showCenter({String msg = "please insert msg", int duration = 2}) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(8), vertical: ScreenSize.fitPxWidth(3)),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 144, 143, 142),
              borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(6)),
            ),
            child: Text(
              msg,
              style: TextStyle(color: Colors.white, fontSize: ScreenSize.fontSize14),
            ),
          ),
        ),
      ),
    );
    _overlay.insert(_overlayEntry);

    Future.delayed(Duration(seconds: duration)).then((value) => {close()});
  }

  void showBottom({String msg = "please insert msg", int duration = 2}) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Container(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(bottom: ScreenSize.fitPxWidth(40)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(8), vertical: ScreenSize.fitPxWidth(3)),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 144, 143, 142),
                borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(6)),
              ),
              child: Text(
                msg,
                style: TextStyle(color: Colors.white, fontSize: ScreenSize.fontSize14),
              ),
            ),
          ),
        ),
      ),
    );
    _overlay.insert(_overlayEntry);

    Future.delayed(Duration(seconds: duration)).then((value) => {close()});
  }

  void close() {
    _overlayEntry.remove();
  }
}
