import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_mediam_match/models/user_model.dart';

import '../../enum/skill_end_drawer_type.dart';

import '../../models/skill_model.dart';

class UserSettingViewProvider extends ChangeNotifier {
  ///EndDrawerのステータス（スキルページ開くよう）
  SkillEndDrawerType endDrawerOpenInfo = SkillEndDrawerType.close;

  String base64Img = "";
  TextEditingController nameInput = TextEditingController();
  TextEditingController jobInput = TextEditingController();
  TextEditingController introductionInput = TextEditingController();

  List<RequestUserSkillData> haveSkillList = [];
  List<RequestUserSkillData> wantSkillList = [];

  ///編集ページにユーザのデータ画面に入る
  void getUserSettingData(LoginUser userData) {
    nameInput.text = userData.name ?? "";
    jobInput.text = userData.job ?? "";
    base64Img = userData.image ?? "";
    introductionInput.text = userData.introduction ?? "";
    haveSkillList = userData.mainSkills ?? [];
    wantSkillList = userData.wantSkills ?? [];
    notifyListeners();
  }

  ///ユーザ画像アップロードすると画面にチェンジ
  Future<void> imageChange() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickerImage = await picker.pickImage(source: ImageSource.gallery, maxHeight: 150, maxWidth: 150);

    if (pickerImage != null) {
      File image = File(pickerImage.path);

      String base64String = base64Encode(image.readAsBytesSync());
      base64Img = base64String;
      notifyListeners();
    }
  }

  ///スキルチェンジ
  void changeSkillList(Map<String, List<RequestUserSkillData>> skillData) {
    haveSkillList = skillData["haveSkillList"]!;
    wantSkillList = skillData["wantSkillList"]!;
    notifyListeners();
  }

  void inputOnChange(String value) {
    introductionInput.text = value;
    notifyListeners();
  }

  ///スキルページ開くとステータス交換
  void changeEndDrawerStatus(SkillEndDrawerType status) {
    endDrawerOpenInfo = status;
    notifyListeners();
  }
}
