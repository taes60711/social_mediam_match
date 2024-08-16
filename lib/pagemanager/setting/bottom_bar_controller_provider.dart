import 'package:flutter/material.dart';

import '../enum/bottom_bar_path.dart';

class BottomBarControllerProvider extends ChangeNotifier {
  int index = 0;
  void bottomBarPageChange(BottomBarPath bottomBarPath) {
    index = bottomBarPath.path;
    print("BottomBar changeToLabel : ${bottomBarPath.label}  indexChangeTo : $index");
    render();
  }

  void bottomBarPageToHome() {
    index = BottomBarPath.home.path;
    print("BottomBar indexChangeTo Home : $index");
    render();
  }

  Future<void> render() async {
    await Future.delayed(Duration.zero);
    notifyListeners();
  }
}
