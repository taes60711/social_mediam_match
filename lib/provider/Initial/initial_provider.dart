import 'package:flutter/material.dart';

class InitialProvider extends ChangeNotifier {
  bool isfirstEnterApp = true;

  bool onChange() {
    isfirstEnterApp = false;
    notifyListeners();
    return isfirstEnterApp;
  }
}
