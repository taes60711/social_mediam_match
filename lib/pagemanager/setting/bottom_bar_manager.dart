import 'package:flutter/material.dart';

import '../enum/bottom_bar_path.dart';

List<BottomNavigationBarItem> bottomBarItems = <BottomNavigationBarItem>[
  BottomNavigationBarItem(icon: BottomBarPath.home.icon, label: BottomBarPath.home.label),
  BottomNavigationBarItem(icon: BottomBarPath.skillExChange.icon, label: BottomBarPath.skillExChange.label),
  BottomNavigationBarItem(icon: BottomBarPath.course.icon, label: BottomBarPath.course.label),
  BottomNavigationBarItem(icon: BottomBarPath.chatRoom.icon, label: BottomBarPath.chatRoom.label),
  BottomNavigationBarItem(icon: BottomBarPath.my.icon, label: BottomBarPath.my.label),
];
