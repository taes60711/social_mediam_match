import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_mediam_match/global.dart';
import 'package:http/http.dart' as http;
import 'package:social_mediam_match/models/user_model.dart';

import '../models/skill_model.dart';

class UserSettingState extends ChangeNotifier {
  //ページに遷移すれば（データ一回しか取得ないため），flagを使う
  bool isFirst = true;
  //サーバーアドレス
  String url = "http://$ip:$port";

  List<SkillModel> forntSkillList = [];
  List<SkillModel> iotSkillList = [];
  List<SkillModel> backEndSkillList = [];
  List<SkillModel> otherSkillList = [];

  String base64Img = "";
  TextEditingController nameInput = TextEditingController();
  TextEditingController introductionInput = TextEditingController();
  final GlobalKey<ScaffoldState> key = GlobalKey();
  String type = "";

  userDataInsertToViewValue(LoginUser userData) async {
    Future.delayed(Duration.zero).then((value) {
      base64Img = userData.image ?? "";
      nameInput.text = userData.name ?? "";
      introductionInput.text = userData.introduction ?? "";
      notifyListeners();
    });
  }

  //ページに遷移する際に、元データ取得する
  Future<bool> getSkillListData(LoginUser userData) async {
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

          SkillInfo haveSkillInfo = SkillInfo(name: e['name'], level: skillLevel, month: 0);
          SkillInfo wantSkillInfo = SkillInfo(name: e['name'], level: skillLevel, month: 0);
          if (skillCheckBool) {
            skillLevel = userData.mainSkills!.firstWhere((element) => element.name == e['name']).level;
            haveSkillInfo = SkillInfo(name: e['name'], level: skillLevel, month: 0);
          }
          if (wantSkillCheckBool) {
            skillLevel = userData.wantSkills!.firstWhere((element) => element.name == e['name']).level;
            wantSkillInfo = SkillInfo(name: e['name'], level: skillLevel, month: 0);
          }

          //全スキル名前とユーザのスキルリスト組み合わせする
          if (forntType.contains(e['name'])) {
            forntSkillList = [...forntSkillList, SkillModel(id: e['id'], skillHave: haveSkillInfo, skillWant: wantSkillInfo)];
          } else if (backendType.contains(e['name'])) {
            backEndSkillList = [...backEndSkillList, SkillModel(id: e['id'], skillHave: haveSkillInfo, skillWant: wantSkillInfo)];
          } else if (iotType.contains(e['name'])) {
            iotSkillList = [...iotSkillList, SkillModel(id: e['id'], skillHave: haveSkillInfo, skillWant: wantSkillInfo)];
          } else {
            otherSkillList = [...otherSkillList, SkillModel(id: e['id'], skillHave: haveSkillInfo, skillWant: wantSkillInfo)];
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
  void checkOnChange(SkillInfo list, {String? choicedLevel}) {
    //いずれスキルのレベル変更する
    list.level = int.parse(choicedLevel ?? "0");
    notifyListeners();
  }

  Future<void> imageChange() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File _image = File(image.path);
      String base64String = base64Encode(_image.readAsBytesSync());
      base64Img = base64String;
      notifyListeners();
    }
  }

  //SQLにアップ前にデータ加工する
  UpdateUser reformatData(
    String uid,
    String image,
    String name,
    String introduction,
    List<SkillModel> forntSkillItems,
    List<SkillModel> iotSkillItems,
    List<SkillModel> backEndSkillItems,
    List<SkillModel> otherSkillItems,
  ) {
    List<SkillInfo> gethaveSkill = [];
    List<SkillInfo> getWantSkill = [];

    //全カテゴリーのスキルリストがリスト化
    List<List<SkillModel>> allcategoryItems = [backEndSkillItems, forntSkillItems, iotSkillItems, otherSkillItems];

    for (var categoryItems in allcategoryItems) {
      for (var items in categoryItems) {
        //データ加工する
        if (items.skillHave.level > 0) {
          gethaveSkill.add(items.skillHave);
        }
        if (items.skillWant.level > 0) {
          getWantSkill.add(items.skillWant);
        }
      }
    }

    return UpdateUser.update(
      uid: uid,
      image: image,
      name: name,
      introduction: introduction,
      mainSkills: gethaveSkill,
      wantSkills: getWantSkill,
    );
  }

  void openSkillselectPage(String type) {
    this.type = type;
    notifyListeners();
  }

  bool isProfileChange(
    LoginUser userData,
    String image,
    String name,
    String introduction,
    List<SkillModel> allSkillItems,
    List<SkillModel> allWantSkillItems,
  ) {
    bool isChange = false;

    if (userData.image != image || userData.name != name || userData.introduction != introduction) {
      isChange = true;
    }

    void getSkillListIsChange(List<SkillInfo> userSkillList, List<SkillInfo> skillList) {
      if (skillList.length != userSkillList.length) {
        isChange = true;
      } else {
        for (var element in skillList) {
          for (var e in userSkillList) {
            if (element.name == e.name) {
              if (element.level != e.level) {
                isChange = true;
              }
            }
          }
        }
      }
    }

    List<SkillInfo> getHaveSkillList = allSkillItems.map((e) => e.skillHave).toList();
    List<SkillInfo> getWantSkillList = allWantSkillItems.map((e) => e.skillWant).toList();
    getSkillListIsChange(userData.mainSkills!, getHaveSkillList);
    getSkillListIsChange(userData.wantSkills!, getWantSkillList);

    print("isProfileChange : $isChange");
    return isChange;
  }
}
