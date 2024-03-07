import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/global.dart';
import 'package:http/http.dart' as http;
import 'package:social_mediam_match/models/user_model.dart';

class SkillModel {
  int id;
  s skillHave;
  s skillWant;

  SkillModel({required this.id, required this.skillHave, required this.skillWant});
}

class s {
  SkillInfo skillInfo;
  bool ishave;
  s({required this.skillInfo, required this.ishave});
}

class UserSettingState extends ChangeNotifier {
  //ページに遷移すれば（データ一回しか取得ないため），flagを使う
  bool isFirst = true;
  //サーバーアドレス
  String url = "http://$ip:$port";

  List<SkillModel> forntSkillList = [];
  List<SkillModel> iotSkillList = [];
  List<SkillModel> backEndSkillList = [];
  List<SkillModel> otherSkillList = [];

  List<String> forntType = ["javascript", "typescript", "css", "html", "vue", "React", "AndroidStudio", "Flutter", "objective-c"];
  List<String> iotType = ["arduino"];
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
          bool skillCheckBool = userData.mainSkills!.indexWhere((element) => element.name == e['name']) != -1;
          bool wantSkillCheckBool = userData.wantSkills!.indexWhere((element) => element.name == e['name']) != -1;
          s have;
          s want;

          SkillInfo haveSkillInfo = SkillInfo(name: e['name'], level: 0, month: 0);
          SkillInfo wantSkillInfo = SkillInfo(name: e['name'], level: 0, month: 0);
          if (skillCheckBool) {
            skillLevel = userData.mainSkills!.firstWhere((element) => element.name == e['name']).level;
            haveSkillInfo = SkillInfo(name: e['name'], level: skillLevel, month: 0);
          }
          if (wantSkillCheckBool) {
            skillLevel = userData.wantSkills!.firstWhere((element) => element.name == e['name']).level;
            wantSkillInfo = SkillInfo(name: e['name'], level: skillLevel, month: 0);
          }

          have = s(skillInfo: haveSkillInfo, ishave: skillCheckBool);
          want = s(skillInfo: wantSkillInfo, ishave: wantSkillCheckBool);

          //全スキル名前とユーザのスキルリスト組み合わせする
          if (forntType.contains(e['name'])) {
            forntSkillList = [...forntSkillList, SkillModel(id: e['id'], skillHave: have, skillWant: want)];
          } else if (backendType.contains(e['name'])) {
            backEndSkillList = [...backEndSkillList, SkillModel(id: e['id'], skillHave: have, skillWant: want)];
          } else if (iotType.contains(e['name'])) {
            iotSkillList = [...iotSkillList, SkillModel(id: e['id'], skillHave: have, skillWant: want)];
          } else {
            otherSkillList = [...otherSkillList, SkillModel(id: e['id'], skillHave: have, skillWant: want)];
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

//いずれスキルに関するやつ変更する
  void checkOnChange(String skillName, List<SkillModel> list, String type, {String? choicedLevel}) {
    int index = list.indexWhere((element) => element.skillHave.skillInfo.name == skillName);
    if (type == "have") {
      //スキルチェックtrue or false
      list[index].skillHave.ishave = !list[index].skillHave.ishave;
    } else if (type == "want") {
      //スキルチェックtrue or false
      list[index].skillWant.ishave = !list[index].skillWant.ishave;
    }
    // } else if (type == "level") {
    //   //いずれスキルのレベル変更する
    //   list[index].skillInfo.level = int.parse(choicedLevel ?? "0");
    // }
    notifyListeners();
  }

  //SQLにアップ前にデータ加工する
  UpdateUser reformatData(
    String uid,
    String name,
    String introduction,
    List<SkillModel> webSkillItems,
    List<SkillModel> iotSkillItems,
    List<SkillModel> backEndSkillItems,
    List<SkillModel> otherSkillItems,
  ) {
    List<SkillInfo> gethaveSkill = [];
    List<SkillInfo> getWantSkill = [];

    //全カテゴリーのスキルリストがリスト化
    List<List<SkillModel>> allcategoryItems = [backEndSkillItems, webSkillItems, iotSkillItems, otherSkillItems];

    for (var categoryItems in allcategoryItems) {
      for (var items in categoryItems) {
        //データ加工する
        if (items.skillHave.ishave) {
          gethaveSkill.add(items.skillHave.skillInfo);
        }
        if (items.skillWant.ishave) {
          getWantSkill.add(items.skillWant.skillInfo);
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
