import 'package:flutter/material.dart';

class InitialState extends ChangeNotifier {
  bool isfirstEnterApp = true;
  bool onChange() {
    isfirstEnterApp = false;
    notifyListeners();
    return isfirstEnterApp;
  }
}
