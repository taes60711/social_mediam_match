import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:social_mediam_match/components/strings/account/sign_up_strings.dart';
import 'package:social_mediam_match/states/user_setting_state.dart';
import '../../../models/skill_model.dart';
import '../../../models/user_model.dart';
import '../../../states/user_state.dart';
import '../../utilities/Icon_with_input.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/skill_list_view.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class SignUpStepTwo extends StatelessWidget {
  final UserState userFuture;
  final String signUpedUserUID;
  final UserSettingState userSettingState;
  final List<SkillModel> allSkillItems;
  final List<SkillModel> allWantSkillItems;
  final TextEditingController nameController;
  final TextEditingController jobController;
  final TextEditingController introductionController;

  const SignUpStepTwo({
    super.key,
    required this.userFuture,
    required this.signUpedUserUID,
    required this.userSettingState,
    required this.allSkillItems,
    required this.allWantSkillItems,
    required this.nameController,
    required this.jobController,
    required this.introductionController,
  });

  @override
  Widget build(BuildContext context) {
    //スキルタイトルボタン、押したらスキル選択ページに遷移する
    skillTitle({required String type}) {
      List<SkillModel> skillItems = type == "have" ? allSkillItems : allWantSkillItems;
      String title = type == "have" ? StepTwoPage().haveSkillText : StepTwoPage().wantSkillText;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: GestureDetector(
          onTap: () {
            print(type);
            userSettingState.openSkillselectPage(type);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                    ),
                  ),
                  Text(
                    "(${skillItems.length} / 7)",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: ScreenSize().width,
                child: SkillListView(
                  skillList: skillItems.map((e) => type == "have" ? e.skillHave : e.skillWant).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Future<void> loadingPopView() {
      return showDialog<void>(
        barrierDismissible: false,
        barrierColor: Color.fromARGB(28, 0, 0, 0),
        context: context,
        builder: (BuildContext context) {
          return LoadingAnimationWidget.inkDrop(color: normalBgColor, size: 35);
        },
      );
    }

    void closePop() {
      if (!ModalRoute.of(context)!.isCurrent) {
        Navigator.of(context).pop();
      }
    }

    return Column(
      children: [
        Text(StepTwoPage().title),
        const SizedBox(height: 10),
        TitleInput(
          title: StepTwoPage().jobInputTitle,
          textController: jobController,
        ),
        TitleInput(
          title: StepTwoPage().introInputTitle,
          textController: introductionController,
          isMulti: true,
        ),
        const SizedBox(height: 15),
        skillTitle(type: "have"),
        const SizedBox(height: 10),
        skillTitle(type: "want"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: CustomButton(
            title: StepTwoPage().sendButtonText,
            titleColor: normalTextColor,
            backgroundColor: normalBgColor,
            onPress: () async {
              loadingPopView();
              print(
                  "nameController : ${nameController.text} jobController : ${jobController.text} introductionController : ${introductionController.text}");
              inspect(allSkillItems);
              inspect(allWantSkillItems);

              List<SkillInfo> gethaveSkill = [];
              List<SkillInfo> getWantSkill = [];
              for (var element in allSkillItems) {
                gethaveSkill.add(element.skillHave);
              }
              for (var element in allWantSkillItems) {
                getWantSkill.add(element.skillWant);
              }
              inspect(gethaveSkill);
              inspect(getWantSkill);

              // UpdateUser updateUserData = UpdateUser.update(
              //   uid: signUpedUserUID,
              //   image: "",
              //   name: nameController.text,
              //   job: jobController.text,
              //   introduction: introductionController.text,
              //   mainSkills: gethaveSkill,
              //   wantSkills: getWantSkill,
              // );
              // bool isSucess = await userFuture.updateProfile(signUpedUserUID, updateUserData);

              // if (isSucess) {
              //   userFuture.onChangeSignUpPage(3);
              // }

              await Future.delayed(const Duration(seconds: 1)).then((value) => closePop());
              userFuture.onChangeSignUpPage(3);
            },
          ),
        ),
      ],
    );
  }
}
