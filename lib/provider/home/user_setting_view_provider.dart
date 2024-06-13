import 'package:flutter/material.dart';

class UserSettingViewProvider extends ChangeNotifier {
  TextEditingController nameInput = TextEditingController();
  TextEditingController jobInput = TextEditingController();
  TextEditingController introductionInput = TextEditingController();

  void inputOnChange(String value) {
    introductionInput.text = value;
    notifyListeners();
  }
}
