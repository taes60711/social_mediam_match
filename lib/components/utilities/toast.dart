import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

class Toast {
  static final Toast _singleton = Toast._internal();

  factory Toast() {
    return _singleton;
  }

  late BuildContext _context;
  late OverlayEntry _overlayEntry;
  late OverlayState _overlay;

  bool _isToastShowing = false;

  Toast._internal();

  void init(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _context = context;
      _overlay = Overlay.of(_context);
    });
  }

  void showCenter({String msg = "please insert msg", int duration = 2}) {
    if (_isToastShowing) {
      return;
    }

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
            child: GestureDetector(
              onDoubleTap: () {
                Clipboard.setData(ClipboardData(text: msg));
              },
              child: Text(
                msg,
                style: TextStyle(color: Colors.white, fontSize: ScreenSize.fontSize14),
              ),
            ),
          ),
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      _overlay.insert(_overlayEntry);
      _isToastShowing = true;

      Future.delayed(Duration(seconds: duration)).then((value) {
        close();
      });
    });
  }

  void showBottom({String msg = "please insert msg", int duration = 2}) {
    if (_isToastShowing) {
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Container(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(bottom: ScreenSize.fitPxWidth(100)),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenSize.fitPxWidth(8),
                vertical: ScreenSize.fitPxWidth(3),
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 44, 44, 42), //const Color.fromARGB(255, 144, 143, 142),
                borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(6)),
              ),
              child: GestureDetector(
                onDoubleTap: () {
                  Clipboard.setData(ClipboardData(text: msg));
                },
                child: Text(
                  msg,
                  style: TextStyle(color: Colors.white, fontSize: ScreenSize.fontSize14),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    _overlay.insert(_overlayEntry);
    _isToastShowing = true;

    Future.delayed(Duration(seconds: duration)).then((value) {
      close();
    });
  }

  void close() {
    if (_isToastShowing) {
      _overlayEntry.remove();
      _isToastShowing = false;
    }
  }
}
