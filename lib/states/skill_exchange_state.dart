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
  List<String> filterSkill = [];
  List<Map<String, dynamic>> forntSkillList = [];
  List<Map<String, dynamic>> iotSkillList = [];
  List<Map<String, dynamic>> backEndSkillList = [];
  List<Map<String, dynamic>> otherSkillList = [];
  bool isFirst = true, isLoading = false;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();

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
          } else {
            otherSkillList = [...otherSkillList, map];
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

  Future<void> getAllUserData({required List<String> filterSkill, required bool isFirstSearch}) async {
    isLoading = true;

    List<LoginUser> userData = [];
    userData = await _dbService.getAllUserData(filterSkill: filterSkill, isFirstSearch: isFirstSearch);

    if (isFirstSearch) {
      allUserData = userData;
    } else {
      for (var element in userData) {
        allUserData.add(element);
      }
    }
    inspect(allUserData);
    isLoading = false;
    notifyListeners();
  }

  void filterOnChange(List<Map<String, dynamic>> list, String skillName) {
    int index = list.indexWhere((element) => element['name'] == skillName);
    list[index]['bool'] = !list[index]['bool'];
    notifyListeners();
  }

  void filterButtonOnClick(
    List<Map<String, dynamic>> forntList,
    List<Map<String, dynamic>> backendList,
    List<Map<String, dynamic>> iotList,
    List<Map<String, dynamic>> otherList,
  ) {
    filterSkill = [];
    List<List<Map<String, dynamic>>> allList = [forntList, backendList, iotList, otherList];
    for (var element in allList) {
      for (var e in element) {
        if (e['bool']) {
          filterSkill.add(e['name']);
        }
      }
    }

    getAllUserData(filterSkill: filterSkill, isFirstSearch: true);
  }
}
