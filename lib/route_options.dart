import 'package:flutter/material.dart';
import 'package:social_mediam_match/global.dart';

class RouteOptions {
  static void pagePop() {
    Navigator.of(globalContext).pop();
  }

  static void pagePushToHome() {
    Navigator.of(globalContext).popUntil(ModalRoute.withName(RoutePath.home.value));
  }
}
