import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/provider/account/signUpPage/sign_up_view_model.dart';
import '../../../enum/skill_type.dart';
import '../../../models/skill_model.dart';
import '../../../provider/account/signUpPage/sign_up_view_provider.dart';
import '../../../provider/home/skill_map_provider.dart';
import '../../../provider/home/user_setting_view_provider.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/title_input.dart';

class SignUpStepThird extends StatelessWidget {
  const SignUpStepThird({super.key});

  @override
  Widget build(BuildContext context) {
    UserSettingViewProvider userSettingViewProvider = context.read<UserSettingViewProvider>();
    print("signUpStepThird");

    return Column(
      children: [
        TitleInput(
          title: StepThirdPage.jobInputTitle,
          textController: userSettingViewProvider.jobInput,
        ),
        Builder(
          builder: (context) {
            print("signUpStepThird introductInput");
            String displayText = context.select((UserSettingViewProvider value) => value.introductionInput.text);
            return MultiTitleInput(
              title: StepThirdPage.introInputTitle,
              textController: userSettingViewProvider.introductionInput,
              displayText: displayText,
              multiOnChange: (value) => userSettingViewProvider.inputOnChange(value),
            );
          },
        ),
        const SizedBox(height: 10),
        skillButton(SignUpEndDrawerType.haveSkill),
        const SizedBox(height: 20),
        skillButton(SignUpEndDrawerType.wantSkill),
        const SizedBox(height: 10),
        sendBtn(context),
      ],
    );
  }
}

Widget sendBtn(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: CustomButton(
      title: StepThirdPage.sendButtonText,
      titleColor: normalTextColor,
      backgroundColor: normalBgColor,
      onPress: () async {
        await SignUpViewModel(context: context).updateUserData();
      },
    ),
  );
}

Widget skillButton(SignUpEndDrawerType type) {
  return Consumer<SkillMapProvider>(builder: (context, skillMapProvider, _) {
    List<RequestUserSkillData> skillData =
        type == SignUpEndDrawerType.haveSkill ? skillMapProvider.haveSkillList : skillMapProvider.wantSkillList;

    String btnText = type == SignUpEndDrawerType.haveSkill ? StepThirdPage.haveSkillText : StepThirdPage.wantSkillText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();
            signUpViewProvider.changeEndDrawerStatus(type);
          },
          child: Row(
            children: [
              Text(btnText),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
              ),
              Text("(${skillData.length} / 5)"),
            ],
          ),
        ),
        skillBar(type),
      ],
    );
  });
}

Widget skillBar(SignUpEndDrawerType type) {
  var levelIcon = {
    1: Icons.filter_1,
    2: Icons.filter_2,
    3: Icons.filter_3,
    4: Icons.filter_4,
    5: Icons.filter_5,
  };
  return Consumer<SkillMapProvider>(builder: (context, skillMapProvider, _) {
    List<RequestUserSkillData> skillData =
        type == SignUpEndDrawerType.haveSkill ? skillMapProvider.haveSkillList : skillMapProvider.wantSkillList;

    return SizedBox(
      width: ScreenSize.width,
      child: Wrap(
        children: skillData.map((e) {
          return Container(
            margin: const EdgeInsets.only(right: 5, bottom: 5),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color.fromARGB(255, 236, 157, 120),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  levelIcon[e.level],
                  color: normalTextColor,
                  size: 18,
                ),
                const SizedBox(width: 5),
                Text(
                  e.name,
                  style: TextStyle(color: normalTextColor, fontSize: 14),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  });
}
