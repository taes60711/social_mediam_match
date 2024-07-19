import 'package:flutter/material.dart';
import 'package:social_mediam_match/global.dart';

import '../enum/route_path.dart';

class RouteOptions {
  static void pop() {
    Navigator.of(globalContext).pop();
  }

  static void popUntilToHome() {
    Navigator.of(globalContext).popUntil(ModalRoute.withName(RoutePath.home.value));
  }

  static void pushTo(RoutePath routePath, {Map<String, dynamic>? arguments}) {
    print("PushPageTo : $routePath  arguments : $arguments");
    Navigator.of(globalContext).pushNamed(routePath.value, arguments: arguments);
  }

  static popAndPushTo(RoutePath routePath, {Map<String, dynamic>? arguments}) {
    Navigator.of(globalContext).pushNamed(routePath.value, arguments: arguments);
  }
}
