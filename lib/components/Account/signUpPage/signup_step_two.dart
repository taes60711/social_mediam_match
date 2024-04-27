import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:social_mediam_match/states/user_setting_state.dart';
import '../../../models/skill_model.dart';
import '../../../states/user_state.dart';
import '../../utilities/Icon_with_input.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/skill_list_view.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class SignUpStepTwo extends StatelessWidget {
  final UserState userFuture;
  final UserSettingState userSettingState;
  final List<SkillModel> allSkillItems;
  final List<SkillModel> allWantSkillItems;
  final TextEditingController nameController;
  final TextEditingController jobController;
  final TextEditingController introductionController;

  const SignUpStepTwo({
    super.key,
    required this.userFuture,
    required this.userSettingState,
    required this.allSkillItems,
    required this.allWantSkillItems,
    required this.nameController,
    required this.jobController,
    required this.introductionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(child: Text("個人資料設定")),
        const SizedBox(height: 10),
        TitleInput(
          title: "職業",
          inputHeight: 36,
          textController: jobController,
        ),
        TitleInput(
          title: "自我介紹",
          textController: introductionController,
          isMulti: true,
        ),
        const SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: GestureDetector(
            onTap: () {
              print("能教的技能");
              userSettingState.openSkillselectPage("have");
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "能教的技能",
                      style: TextStyle(fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      ),
                    ),
                    Text(
                      "(${allSkillItems.length}/7)",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(
                  width: ScreenSize().width,
                  child: SkillListView(
                    skillList: allSkillItems.map((e) => e.skillHave).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: GestureDetector(
            onTap: () {
              print("想學的技能");
              userSettingState.openSkillselectPage("want");
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "想學的技能",
                      style: TextStyle(fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      ),
                    ),
                    Text(
                      "(${allWantSkillItems.length}/7)",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(
                  width: ScreenSize().width,
                  child: SkillListView(
                    skillList: allWantSkillItems.map((e) => e.skillWant).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: CustomButton(
            title: "送出",
            titleColor: normalTextColor,
            backgroundColor: normalBgColor,
            onPress: () async {
              print(
                  "nameController : ${nameController.text} jobController : ${jobController.text} introductionController : ${introductionController.text}");
              inspect(allSkillItems);
              inspect(allWantSkillItems);

              // bool isSucess = await userFuture.updateProfile(userData.uid, updateUserData);
              bool isSucess = true;
              if (isSucess) {
                userFuture.onChangePage(3);
              }
            },
          ),
        ),
      ],
    );
  }
}
