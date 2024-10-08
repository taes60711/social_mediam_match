import 'package:flutter/material.dart';

class InitialProvider extends ChangeNotifier {
  ///MARK: テスト用
  bool needTestIpInputPage = false;

  void toFirstEnterAppPage() {
    needTestIpInputPage = false;
    notifyListeners();
  }

  bool isfirstEnterApp = true;

  bool onChange() {
    isfirstEnterApp = false;
    notifyListeners();
    return isfirstEnterApp;
  }
}
