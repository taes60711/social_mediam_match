import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/global.dart';
import 'package:http/http.dart' as http;
import 'package:social_mediam_match/models/user_model.dart';

class SkillModel extends ChangeNotifier {
  int id;
  SkillInfo skillInfo;
  bool haveSkill;
  bool wantSkill;
  SkillModel({required this.id, required this.skillInfo, required this.haveSkill, required this.wantSkill});
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
        List<dynamic> jsonData = json.decode(response.body);
        for (var e in jsonData) {
          //Switchコンポーネントためにユーザのスキル、勉強したいBool List作成する
          int skillLevel = 0;
          int skillMonth = 0;
          bool skillCheckBool = userData.mainSkills!.indexWhere((element) => element.name == e['name']) != -1;
          bool wantSkillCheckBool = userData.wantSkills!.indexWhere((element) => element.name == e['name']) != -1;

          if (skillCheckBool) {
            skillLevel = userData.mainSkills!.firstWhere((element) => element.name == e['name']).level;
          }
          //全スキル名前とユーザのスキルリスト組み合わせする
          if (forntType.contains(e['name'])) {
            SkillInfo skillInfo = SkillInfo(name: e['name'], level: skillLevel, month: skillMonth);
            forntSkillList = [
              ...forntSkillList,
              SkillModel(id: e['id'], skillInfo: skillInfo, haveSkill: skillCheckBool, wantSkill: wantSkillCheckBool)
            ];
          } else if (backendType.contains(e['name'])) {
            SkillInfo skillInfo = SkillInfo(name: e['name'], level: skillLevel, month: skillMonth);
            backEndSkillList = [
              ...backEndSkillList,
              SkillModel(id: e['id'], skillInfo: skillInfo, haveSkill: skillCheckBool, wantSkill: wantSkillCheckBool)
            ];
          } else {
            SkillInfo skillInfo = SkillInfo(name: e['name'], level: skillLevel, month: skillMonth);
            otherSkillList = [
              ...otherSkillList,
              SkillModel(id: e['id'], skillInfo: skillInfo, haveSkill: skillCheckBool, wantSkill: wantSkillCheckBool)
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
      int index = backEndSkillList.indexWhere((e) => e.skillInfo.name == skillName);
      backEndSkillList[index].haveSkill = !backEndSkillList[index].haveSkill;
    } else if (type == "web_have") {
      int index = forntSkillList.indexWhere((e) => e.skillInfo.name == skillName);
      forntSkillList[index].haveSkill = !forntSkillList[index].haveSkill;
    } else if (type == "other_have") {
      int index = otherSkillList.indexWhere((e) => e.skillInfo.name == skillName);
      otherSkillList[index].haveSkill = !otherSkillList[index].haveSkill;
    } else if (type == "backend_want") {
      int index = backEndSkillList.indexWhere((e) => e.skillInfo.name == skillName);
      backEndSkillList[index].wantSkill = !backEndSkillList[index].wantSkill;
    } else if (type == "web_want") {
      int index = forntSkillList.indexWhere((e) => e.skillInfo.name == skillName);
      forntSkillList[index].wantSkill = !forntSkillList[index].wantSkill;
    } else if (type == "other_want") {
      int index = otherSkillList.indexWhere((e) => e.skillInfo.name == skillName);
      otherSkillList[index].wantSkill = !otherSkillList[index].wantSkill;
    }
    notifyListeners();
  }

  //いずれチェック押したら変更する
  void skillLevelOnchange(String skillName, String choicedLevel, String type) {
    if (type == "backend_have") {
      int index = backEndSkillList.indexWhere((e) => e.skillInfo.name == skillName);
      backEndSkillList[index].skillInfo.level = int.parse(choicedLevel);
    } else if (type == "web_have") {
      int index = forntSkillList.indexWhere((e) => e.skillInfo.name == skillName);
      forntSkillList[index].skillInfo.level = int.parse(choicedLevel);
    } else if (type == "other_have") {
      int index = otherSkillList.indexWhere((e) => e.skillInfo.name == skillName);
      otherSkillList[index].skillInfo.level = int.parse(choicedLevel);
    }

    notifyListeners();
  }

  //SQLにアップ前にデータ加工する
  UpdateUser reformatData(
    String uid,
    String name,
    String introduction,
    List<SkillModel> webSkillItems,
    List<SkillModel> backEndSkillItems,
    List<SkillModel> otherSkillItems,
  ) {
    List<SkillInfo> gethaveSkill = [];
    List<SkillInfo> getWantSkill = [];

    //全カテゴリーのスキルリストがリスト化
    List<List<SkillModel>> allcategoryItems = [backEndSkillItems, webSkillItems, otherSkillItems];

    for (var categoryItems in allcategoryItems) {
      for (var items in categoryItems) {
        //データ加工する
        if (items.haveSkill) {
          gethaveSkill.add(items.skillInfo);
        }
        if (items.wantSkill) {
          getWantSkill.add(items.skillInfo);
        }
      }
    }

    return UpdateUser.update(
      uid: uid,
      name: name,
      introduction: introduction,
      mainSkills: gethaveSkill,
      wantSkills: getWantSkill,
    );
  }
}
