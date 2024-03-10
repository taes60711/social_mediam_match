import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/states/services/db_service.dart';

import '../global.dart';

class SkillExChangeState extends ChangeNotifier {
  final DBService _dbService = DBService();
  //サーバーアドレス
  String url = "http://$ip:$port";
  List<LoginUser> allUserData = [];

  List<Map<String, dynamic>> forntSkillList = [];
  List<Map<String, dynamic>> iotSkillList = [];
  List<Map<String, dynamic>> backEndSkillList = [];

  bool isFirst = true;

  Future<bool> getSkillList() async {
    bool result = false;
    var uri = Uri.parse('$url/skill/getList');
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        List<dynamic> jsonData = json.decode(response.body);
        for (var e in jsonData) {
          Map<String, dynamic> map = {"name": e['name'], "bool": false};

          if (forntType.contains(e['name'])) {
            forntSkillList = [...forntSkillList, map];
          } else if (backendType.contains(e['name'])) {
            backEndSkillList = [...backEndSkillList, map];
          } else if (iotType.contains(e['name'])) {
            iotSkillList = [...iotSkillList, map];
          }
        }
        isFirst = false;
        notifyListeners();
        result = true;
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<void> getAllUserData({List<String>? filterSkill}) async {
    if (filterSkill != null) {
      allUserData = await _dbService.getAllUserData(filterSkill: filterSkill);
    } else {
      allUserData = await _dbService.getAllUserData();
    }
    inspect(allUserData);
    notifyListeners();
  }

  void filterOnChange(List<Map<String, dynamic>> list, String skillName) {
    int index = list.indexWhere((element) => element['name'] == skillName);
    list[index]['bool'] = !list[index]['bool'];
    notifyListeners();
  }

  void FilterButtonOnClick(
    List<Map<String, dynamic>> forntList,
    List<Map<String, dynamic>> backendList,
    List<Map<String, dynamic>> iotList,
  ) {
    List<String>? filterSkill = [];
    forntList.forEach((element) {
      if (element['bool']) {
        filterSkill!.add(element['name']);
      }
    });
    backendList.forEach((element) {
      if (element['bool']) {
        filterSkill!.add(element['name']);
      }
    });
    iotList.forEach((element) {
      if (element['bool']) {
        filterSkill!.add(element['name']);
      }
    });
    if (filterSkill!.length == 0) {
      filterSkill = null;
    }
    getAllUserData(filterSkill: filterSkill);
  }
}
