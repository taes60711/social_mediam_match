import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:social_mediam_match/models/user_model.dart';

import '../enum/skill_type.dart';
import '../global.dart';

class SkillExChangeState extends ChangeNotifier {
  //サーバーアドレス
  String url = "http://$ip:$port";
  List<LoginUser> allUserData = [];
  List<String> filterSkill = [];
  List<Map<String, dynamic>> forntSkillList = [];
  List<Map<String, dynamic>> iotSkillList = [];
  List<Map<String, dynamic>> backEndSkillList = [];
  List<Map<String, dynamic>> otherSkillList = [];
  LoginUser? otherUser;
  bool isFirst = true, isAddDataLoading = false, isReLoading = false, isFirstLoading = true;
  String endDrawerType = "";
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  bool floatButtonIsVisiable = false;

  double startScrollPosition = -1;
  void getStartScrollPos(double pos) {
    startScrollPosition = pos;
    notifyListeners();
  }

  void floatButtonVisiableChange(double posheight) {
    if (posheight < 40) {
      if (floatButtonIsVisiable) {
        floatButtonIsVisiable = false;
        notifyListeners();
      }
    } else {
      if (!floatButtonIsVisiable) {
        floatButtonIsVisiable = true;
        notifyListeners();
      }
    }
  }

  void skillExchangePageDisPose() {
    isFirstLoading = true;
    notifyListeners();
  }

  Future<bool> getSkillList() async {
    bool result = false;
    var uri = Uri.parse('$url/skill/getList');
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        List<dynamic> jsonData = json.decode(response.body);
        for (var e in jsonData) {
          Map<String, dynamic> map = {"name": e['name'], "bool": false};

          if (frontType.contains(e['name'])) {
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

  void addData() {
    isAddDataLoading = true;
    notifyListeners();
  }

  void reLoadingPage() {
    isReLoading = true;
    notifyListeners();
  }

  void filterOnChange(List<Map<String, dynamic>> list, String skillName) {
    int index = list.indexWhere((element) => element['name'] == skillName);
    list[index]['bool'] = !list[index]['bool'];
    notifyListeners();
  }
}
