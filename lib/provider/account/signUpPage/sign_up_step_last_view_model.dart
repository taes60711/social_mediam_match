import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../components/account/account_main_page.dart';
import '../../../components/utilities/lodaing_dialog.dart';
import '../../../models/skill_model.dart';
import '../../../models/user_model.dart';
import '../../../services/image_service.dart';
import '../../../services/user_service.dart';

class SignUpStepLastViewModel {
  BuildContext? context;
  WidgetRef? ref;
  SignUpStepLastViewModel({this.ref, this.context});

  String? editImg;
  List<RequestUserSkillData> mainSkillList = [];
  List<RequestUserSkillData> wantSkillList = [];
  TextEditingController jobController = TextEditingController();
  TextEditingController introductionController = TextEditingController();

  Future<void> uploadProfileData() async {
    LoadingDialog().show(loadingMsg: "上傳資料中...");
    String uid = ref!.read(viewModelProvider.notifier).state.signUpedUserUID;

    String httpImg = "";

    if (editImg != "" && editImg != null) {
      String uid = const Uuid().v1();

      String imageIsExistId = await ImageService().imageIsExist(editImg ?? "");

      if (imageIsExistId != "-1") {
        uid = imageIsExistId;
      } else {
        await ImageService().saveImg(uid, editImg ?? "");
      }

      httpImg = "http://\$ip:\$port/images/$uid";
    }

    UpdateUser sqlUpdateData = UpdateUser.update(
      uid: uid,
      job: jobController.text,
      image: httpImg, // editImg,
      introduction: introductionController.text,
      mainSkills: mainSkillList,
      wantSkills: wantSkillList,
      isEmailVerified: true,
    );
    await UserService().updateUserData(uid, sqlUpdateData);
    LoadingDialog().close();
  }

  ///ユーザ画像アップロードすると画面にチェンジ
  Future<void> imageChange() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickerImage = await picker.pickImage(source: ImageSource.gallery); //, maxHeight: 150, maxWidth: 150

    if (pickerImage != null) {
      File image = File(pickerImage.path);

      String base64String = base64Encode(image.readAsBytesSync());
      editImg = base64String;

      print("editImg");
    }
  }
}
