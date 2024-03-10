import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/states/services/db_service.dart';

class SkillExChangeState extends ChangeNotifier {
  final DBService _dbService = DBService();
  List<LoginUser> allUserData = [];

  Future<void> getAllUserData() async {
    allUserData = await _dbService.getAllUserData();
    inspect(allUserData);
    notifyListeners();
  }
}
