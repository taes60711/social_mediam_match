import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/states/services/db_service.dart';

class SkillExChangePage extends StatelessWidget {
  const SkillExChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {
        DBService().getAllUserData();
      },
      child: Container(),
    );
  }
}
