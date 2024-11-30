import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';

import '../../models/skill_model.dart';
import '../../models/user_model.dart';

class ProfileEditingModel {
  String? avatar;
  final String name;
  final String job;
  final String introduction;
  final List<RequestUserSkillData> mainSkillList;
  final List<RequestUserSkillData> wantSkillList;
  ProfileEditingModel({
    this.avatar,
    required this.name,
    required this.job,
    required this.introduction,
    required this.mainSkillList,
    required this.wantSkillList,
  });

  ProfileEditingModel copyWithProfile() {
    return ProfileEditingModel(
      avatar: avatar,
      name: name,
      job: job,
      introduction: introduction,
      mainSkillList: mainSkillList.map((e) => e.copy()).toList(),
      wantSkillList: wantSkillList.map((e) => e.copy()).toList(),
    );
  }

  ProfileEditingModel.emptyData()
      : avatar = null,
        name = '',
        job = '',
        introduction = '',
        mainSkillList = [],
        wantSkillList = [];

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'name': name,
      'job': job,
      'introduction': introduction,
      'mainSkillList': mainSkillList.map((e) => e.toJson()).toList(),
      'wantSkillList': wantSkillList.map((e) => e.toJson()).toList(),
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}

/// UserProfileEditViewModel
class UserProfileEditViewModel {
  late BuildContext context;
  late WidgetRef ref;
  late Function render;

  void init(BuildContext context, WidgetRef ref, Function render) {
    this.context = context;
    this.ref = ref;
    this.render = render;
    initData();
  }

  ProfileEditingModel beforeEditData = ProfileEditingModel.emptyData();
  ProfileEditingModel editData = ProfileEditingModel.emptyData();

  String? editImg;
  TextEditingController nameController = TextEditingController();
  String errMsg = "";
  TextEditingController jobController = TextEditingController();
  TextEditingController introductionController = TextEditingController();
  List<RequestUserSkillData> mainSkillList = [];
  List<RequestUserSkillData> wantSkillList = [];

  ///ユーザデータ　insert
  void initData() {
    ProfileData editUserData = ref.read(loginUserData);

    editData = ProfileEditingModel(
      avatar: editUserData.image,
      name: editUserData.name ?? "",
      job: editUserData.job ?? "",
      introduction: editUserData.introduction ?? "",
      mainSkillList: editUserData.mainSkills!.map((e) => e.copy()).toList(),
      wantSkillList: editUserData.wantSkills!.map((e) => e.copy()).toList(),
    );

    beforeEditData = editData.copyWithProfile();

    editImg = editData.avatar;
    nameController.text = editData.name;
    jobController.text = editData.job;
    introductionController.text = editData.introduction;

    mainSkillList = List.from(editData.mainSkillList);
    wantSkillList = List.from(editData.wantSkillList);
    render();
  }

  ///　クロース前に編集したことあるのチェック
  bool closePageCheck() {
    bool canClose = false;
    updateEditData();

    bool isEdited = editData.toJsonString() != beforeEditData.toJsonString();
    if (!isEdited) {
      canClose = true;
    }
    return canClose;
  }

  ///編集しているデータアップ
  void updateEditData() {
    editData = ProfileEditingModel(
      avatar: editImg,
      name: nameController.text,
      job: jobController.text,
      introduction: introductionController.text,
      mainSkillList: mainSkillList,
      wantSkillList: wantSkillList,
    );
  }

  ///ユーザ画像アップロードすると画面にチェンジ
  Future<void> avatarChange() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickerImage = await picker.pickImage(source: ImageSource.gallery); //, maxHeight: 150, maxWidth: 150

    if (pickerImage != null) {
      File image = File(pickerImage.path);

      String base64String = base64Encode(image.readAsBytesSync());
      editImg = base64String;
      render();
    }
  }

  /// 投稿前の空欄チェック
  bool sendBeforeCheck() {
    bool isOk = true;
    errMsg = "";
    if (nameController.text == "") {
      errMsg = "名稱不得為空";
      isOk = false;
    }

    render();

    return isOk;
  }
}
