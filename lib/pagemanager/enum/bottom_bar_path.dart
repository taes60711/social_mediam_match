// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum BottomBarPath {
  home("主頁", FontAwesomeIcons.home, 0),
  skillExChange("技能交換", FontAwesomeIcons.solidFaceLaugh, 1),
  course("技術分享", FontAwesomeIcons.bookOpenReader, 2),
  chatRoom("聊天室", FontAwesomeIcons.solidComments, 3),
  my("我的", FontAwesomeIcons.solidUser, 4);

  final String label;
  final IconData icon;
  final int path;

  const BottomBarPath(this.label, this.icon, this.path);
}
