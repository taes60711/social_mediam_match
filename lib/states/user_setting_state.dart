import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/global.dart';
import 'package:http/http.dart' as http;
import 'package:social_mediam_match/models/user_model.dart';

class SkillModel extends ChangeNotifier {
  int id;
  String skillName;
  bool haveSkill;
  bool wantSkill;
  SkillModel({required this.id, required this.skillName, required this.haveSkill, required this.wantSkill});
}

class UserSettingState extends ChangeNotifier {
  //ページに遷移するのflag
  bool isFirst = true;
  //サーバーアドレス
  String url = "http://$ip:$port";

  List<SkillModel> forntSkillList = [];
  List<SkillModel> backEndSkillList = [];
  List<SkillModel> otherSkillList = [];

  List<String> forntType = ["javascript", "typescript", "css", "html", "vue", "React", "AndroidStudio", "Flutter", "objective-c"];
  List<String> backendType = ["java", "python", "mysql"];

  //ページに遷移する際に、元データ取得する
  Future<bool> getPageAllData(LoginUser userData) async {
    bool result = false;
    var uri = Uri.parse('$url/skill/getList');
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        List<dynamic> jsonData = json.decode(response.body) as List<dynamic>;
        for (var e in jsonData) {
          //Switchコンポーネントためにユーザのスキル、勉強したいBool List作成する
          bool skillCheckBool = userData.mainSkills!.contains(e['name']);
          bool wantSkillCheckBool = userData.wantSkills!.contains(e['name']);
          //全スキル名前とユーザのスキルリスト組み合わせする
          if (forntType.contains(e['name'])) {
            forntSkillList = [
              ...forntSkillList,
              SkillModel(id: e['id'], skillName: e['name'], haveSkill: skillCheckBool, wantSkill: wantSkillCheckBool)
            ];
          } else if (backendType.contains(e['name'])) {
            backEndSkillList = [
              ...backEndSkillList,
              SkillModel(id: e['id'], skillName: e['name'], haveSkill: skillCheckBool, wantSkill: wantSkillCheckBool)
            ];
          } else {
            otherSkillList = [
              ...otherSkillList,
              SkillModel(id: e['id'], skillName: e['name'], haveSkill: skillCheckBool, wantSkill: wantSkillCheckBool)
            ];
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

//いずれチェック押したら変更する
  void checkOnChange(String skillName, String type) {
    if (type == "backend_have") {
      int index = backEndSkillList.indexWhere((e) => e.skillName == skillName);
      backEndSkillList[index].haveSkill = !backEndSkillList[index].haveSkill;
    } else if (type == "web_have") {
      int index = forntSkillList.indexWhere((e) => e.skillName == skillName);
      forntSkillList[index].haveSkill = !forntSkillList[index].haveSkill;
    } else if (type == "other_have") {
      int index = otherSkillList.indexWhere((e) => e.skillName == skillName);
      otherSkillList[index].haveSkill = !otherSkillList[index].haveSkill;
    } else if (type == "backend_want") {
      int index = backEndSkillList.indexWhere((e) => e.skillName == skillName);
      backEndSkillList[index].wantSkill = !backEndSkillList[index].wantSkill;
    } else if (type == "web_want") {
      int index = forntSkillList.indexWhere((e) => e.skillName == skillName);
      forntSkillList[index].wantSkill = !forntSkillList[index].wantSkill;
    } else if (type == "other_want") {
      int index = otherSkillList.indexWhere((e) => e.skillName == skillName);
      otherSkillList[index].wantSkill = !otherSkillList[index].wantSkill;
    }
    notifyListeners();
  }

  //SQLにアップデート前にデータ加工する
  UpdateUser reformatData(
    String uid,
    String name,
    List<SkillModel> webSkillItems,
    List<SkillModel> backEndSkillItems,
    List<SkillModel> otherSkillItems,
  ) {
    List<String> gethaveSkill = [];
    List<String> getWantSkill = [];

    for (var element in backEndSkillItems) {
      if (element.haveSkill) {
        gethaveSkill.add(element.skillName);
      }
      if (element.wantSkill) {
        getWantSkill.add(element.skillName);
      }
    }

    for (var element in webSkillItems) {
      if (element.haveSkill) {
        gethaveSkill.add(element.skillName);
      }
      if (element.wantSkill) {
        getWantSkill.add(element.skillName);
      }
    }

    for (var element in otherSkillItems) {
      if (element.haveSkill) {
        gethaveSkill.add(element.skillName);
      }
      if (element.wantSkill) {
        getWantSkill.add(element.skillName);
      }
    }

    return UpdateUser.update(
      uid: uid,
      name: name,
      mainSkills: gethaveSkill,
      wantSkills: getWantSkill,
    );
  }
}
