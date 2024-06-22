// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum BottomBarPath {
  home("主頁", Icon(FontAwesomeIcons.home), 0),
  skillExChange("技能交換", Icon(FontAwesomeIcons.solidFaceLaugh), 1),
  course("課程", Icon(FontAwesomeIcons.bookOpenReader), 2),
  chatRoom("聊天室", Icon(FontAwesomeIcons.solidComments), 3),
  my("我的", Icon(FontAwesomeIcons.solidUser), 4);

  final String label;
  final Icon icon;
  final int path;

  const BottomBarPath(this.label, this.icon, this.path);
}
