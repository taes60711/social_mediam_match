import 'package:flutter/material.dart';

class InitialProvider extends ChangeNotifier {
  ///MARK: テスト用
  bool needTestIpInputPage = true;

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
