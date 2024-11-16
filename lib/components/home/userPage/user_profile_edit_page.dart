import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:social_mediam_match/components/utilities/bottomSheets/base_bottom_sheet.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/services/user_service.dart';

import '../../../models/skill_model.dart';
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../utilities/basic_top_bar.dart';
import '../../utilities/main_button.dart';
import '../../utilities/endDrawers/user_skill_choice_page.dart';
import '../../utilities/inputField/base_input.dart';
import '../../utilities/inputField/mutl_input.dart';
import '../../utilities/user_icon.dart';
import '../skillExChangePage/skill_utilites.dart';

class UserProfileEditPage extends BaseBottomSheet {
  bool isInit = false;
  @override
  double buildHeight() {
    return 0.92;
  }

  @override
  BottomSheetPageType bottomSheetPageType() {
    return BottomSheetPageType.edit;
  }

  @override
  bool buildneedbarrerierClose() {
    return false;
  }

  String? editImg;
  TextEditingController nameController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController introductionController = TextEditingController();
  List<RequestUserSkillData> mainSkillList = [];
  List<RequestUserSkillData> wantSkillList = [];

  @override
  Future<void> initState(WidgetRef ref) async {
    await Future(() {
      ProfileData editUserData = ref.read(loginUserData);
      editImg = editUserData.image;
      nameController.text = editUserData.name ?? "";
      jobController.text = editUserData.job ?? "";
      introductionController.text = editUserData.introduction ?? "";

      mainSkillList = List.from(editUserData.mainSkills ?? []);
      wantSkillList = List.from(editUserData.wantSkills ?? []);
    });

    isInit = true;
    render();
  }

  @override
  Widget build(WidgetRef ref) {
    Widget component = Container();
    if (isInit) {
      return Column(
        children: [
          BaseTopBar(
            leftWidget: downCloseBtn(onPress: () => closePage()),
            title: "個人資料",
            rightWidget: MainBtn(
              onPress: () async {
                ProfileData updateData = ref.read(loginUserData);
                updateData = updateData.copyWith(
                  data: ProfileData(
                    uid: updateData.uid,
                    email: updateData.email,
                    token: updateData.token,
                    image: editImg,
                    name: nameController.text,
                    mainSkills: List.from(mainSkillList),
                    wantSkills: List.from(wantSkillList),
                    job: jobController.text,
                    introduction: introductionController.text,
                    isEmailVerified: updateData.isEmailVerified,
                    status: updateData.status,
                    lastLogin: updateData.lastLogin,
                  ),
                );
                UpdateUser sqlUpdateData = UpdateUser.update(
                  uid: updateData.uid,
                  name: updateData.name,
                  job: updateData.job,
                  introduction: updateData.introduction,
                  mainSkills: updateData.mainSkills,
                  wantSkills: updateData.wantSkills,
                );
                await UserService().sqlUpdateUserData(updateData.uid, sqlUpdateData);

                ref.read(loginUserData.notifier).update((state) => updateData);
                render();
                closePage();
              },
              title: "更新",
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
                child: Column(
                  children: [
                    UserIcon(iconSize: 100, image: editImg),
                    SizedBox(height: ScreenSize.fitPxWidth(15)),
                    //アイコン選択
                    MainBtn(
                      padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(20), vertical: ScreenSize.fitPxWidth(8)),
                      onPress: () async {
                        await imageChange();
                      },
                      title: "選擇圖像",
                    ),
                    inputField(hintText: "名前", editingController: nameController),
                    SizedBox(height: ScreenSize.fitPxWidth(8)),
                    //強いスキル設定
                    MainBtn(
                      onPress: () {
                        UserSkillChoicePage(
                          initSkillData: mainSkillList,
                          updateSkillDate: (List<RequestUserSkillData> value) {
                            mainSkillList = value;
                            render();
                          },
                        ).show(context);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          skillTitle(
                            titile: "能教的技能",
                            iconData: FontAwesomeIcons.reply,
                            iconBgColor: const Color.fromARGB(255, 138, 138, 138),
                          ),
                          SizedBox(height: ScreenSize.fitPxWidth(5)),
                          SkillUtilites().skillBar(skills: mainSkillList),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenSize.fitPxWidth(8)),
                    //弱いスキル設定
                    MainBtn(
                      onPress: () {
                        UserSkillChoicePage(
                          initSkillData: wantSkillList,
                          updateSkillDate: (List<RequestUserSkillData> value) {
                            wantSkillList = value;
                            render();
                          },
                        ).show(context);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          skillTitle(
                            titile: "想學的技能",
                            iconData: FontAwesomeIcons.share,
                            iconBgColor: const Color.fromARGB(255, 240, 123, 77),
                          ),
                          SizedBox(height: ScreenSize.fitPxWidth(5)),
                          SkillUtilites().skillBar(skills: wantSkillList),
                        ],
                      ),
                    ),

                    SizedBox(height: ScreenSize.fitPxWidth(8)),
                    inputField(hintText: "職業", editingController: jobController),
                    SizedBox(height: ScreenSize.fitPxWidth(8)),
                    // 自己紹介
                    multiInputField(hintText: "自我介紹", editingController: introductionController),
                    SizedBox(height: ScreenSize.fitPxWidth(8)),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return component;
  }

  Widget skillTitle({required Color iconBgColor, required IconData iconData, required String titile}) {
    return Row(
      children: [
        ///タイトル
        Container(
          padding: EdgeInsets.all(ScreenSize.fitPxWidth(4)),
          margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            iconData,
            color: AppColors.whiteColor,
            size: ScreenSize.fitPxWidth(12),
          ),
        ),
        Text(
          titile,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: ScreenSize.fontSize18,
          ),
        ),
      ],
    );
  }

  Widget inputField({required String hintText, required TextEditingController editingController, double? fontSzie}) {
    double fs = fontSzie ?? ScreenSize.fontSize16;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText,
          style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(8), vertical: ScreenSize.fitPxWidth(6)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.greyColor130,
            ),
          ),
          child: BaseInputField(
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors.greyColor130, fontSize: fs),
            inputStyle: TextStyle(color: AppColors.whiteColor, fontSize: fs),
            controller: editingController,
          ),
        ),
      ],
    );
  }

  Widget multiInputField({required String hintText, required TextEditingController editingController, double? fontSzie}) {
    double fs = fontSzie ?? ScreenSize.fontSize16;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText,
          style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
        ),
        SizedBox(height: ScreenSize.fitPxWidth(5)),
        MultInput(
          controller: introductionController,
          hintText: hintText,
          minLines: 5,
          maxLines: 5,
          editPageMaxLines: 12,
          editPageMinLines: 12,
          hintStyle: TextStyle(color: AppColors.greyColor130, fontSize: fs),
          inputStyle: TextStyle(color: AppColors.whiteColor, fontSize: fs),
        ),
      ],
    );
  }

  ///ユーザ画像アップロードすると画面にチェンジ
  Future<void> imageChange() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickerImage = await picker.pickImage(source: ImageSource.gallery); //, maxHeight: 150, maxWidth: 150

    if (pickerImage != null) {
      File image = File(pickerImage.path);

      String base64String = base64Encode(image.readAsBytesSync());
      editImg = base64String;
      render();
    }
  }
}
