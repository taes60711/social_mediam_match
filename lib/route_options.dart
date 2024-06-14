import 'package:flutter/material.dart';
import 'package:social_mediam_match/global.dart';

import 'enum/route_path.dart';

class RouteOptions {
  static void pagePop() {
    Navigator.of(globalContext).pop();
  }

  static void pagePushToHome() {
    Navigator.of(globalContext).popUntil(ModalRoute.withName(RoutePath.home.value));
  }
}

class BottomBarControllerProvider extends ChangeNotifier {
  int index = 0;
  void bottomBarPageChange(int selectedIndex) {
    index = selectedIndex;
    print("selectedIndex : $index");
    notifyListeners();
  }
}
