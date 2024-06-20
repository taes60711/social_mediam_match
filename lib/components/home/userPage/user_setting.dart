import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/fit_widget.dart';
import 'package:social_mediam_match/provider/home/user_setting_view_model.dart';
import 'package:social_mediam_match/provider/home/user_setting_view_provider.dart';
import '../../../enum/skill_type.dart';

import '../../account/skill_bar.dart';
import '../../account/skill_choice_setting_page.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../strings/userPage/user_page_string.dart';
import '../../utilities/background_widget.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/stateful_wrapper.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/title_input.dart';
import '../../utilities/user_icon.dart';

class UserSetting extends StatelessWidget {
  const UserSetting({super.key});

  @override
  Widget build(BuildContext context) {
    print("userSetting build");

    return Stack(
      children: [
        BackgroundWidget(
          isSafeArea: true,
          child: StatefulWrapper(
            onInit: () async => await UserSettingViewModel(context: context).init(),
            child: _mainBody(context),
          ),
        ),
        endDrawer(),
      ],
    );
  }
}

Widget _mainBody(BuildContext context) {
  UserSettingViewProvider userSettingViewProvider = context.read<UserSettingViewProvider>();
  return Column(
    children: [
      BaseTopBar(
        backFunc: () => UserSettingViewModel(context: context).checkIsEdit(),
        title: ProfileString().title,
      ),

      ///Avatar
      userAvatar,

      ///AvatarEdit
      avatarEdit(context),

      ///name
      TitleInput(
        title: StepTwoPage.nameInputTitle,
        textController: userSettingViewProvider.nameInput,
      ),

      ///job
      TitleInput(
        title: StepThirdPage.jobInputTitle,
        textController: userSettingViewProvider.jobInput,
      ),
      const SizedBox(height: 10),

      ///スキル
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: skillSettingTitleBarBtn(SkillEndDrawerType.haveSkill),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: skillSettingTitleBarBtn(SkillEndDrawerType.wantSkill),
      ),
      const SizedBox(height: 10),

      ///introduction
      Builder(
        builder: (context) {
          print("userSetting introductInput");
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

      ///更新ボタン
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomButton(
          title: ProfileString().updateButtonText,
          titleColor: normalTextColor,
          backgroundColor: normalBgColor,
          onPress: () {
            UserSettingViewModel(context: context).updateUserData();
          },
        ),
      )
    ],
  );
}

///Avatar
Widget userAvatar = Builder(
  builder: (context) {
    String base64Img = context.select((UserSettingViewProvider value) => value.base64Img);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenSize.safeHeight * 0.025),
      child: FitWidget(
        height: ScreenSize.safeHeight * 0.15,
        child: UserIcon(iconSize: 120, image: base64Img),
      ),
    );
  },
);

///AvatarEdit
Widget avatarEdit(BuildContext context) {
  UserSettingViewProvider userSettingViewProvider = context.read<UserSettingViewProvider>();
  return FitWidget(
    height: ScreenSize.safeHeight * 0.05,
    child: CustomButton(
      width: 150,
      title: ProfileString().imgPickerButtonText,
      titleColor: normalTextColor,
      backgroundColor: googleColor,
      onPress: () async {
        await userSettingViewProvider.imageChange();
      },
    ),
  );
}

Widget endDrawer() {
  return Builder(builder: (context) {
    print("customEndDrawer");
    SkillEndDrawerType endDrawer = context.select((UserSettingViewProvider value) => value.endDrawerOpenInfo);

    UserSettingViewProvider userSettingViewProvider = context.read<UserSettingViewProvider>();

    Widget endDrawerWidget = Container();

    if (endDrawer == SkillEndDrawerType.haveSkill) {
      endDrawerWidget = SkillChoiceSettingPage(
        skillType: SkillEndDrawerType.haveSkill,
        onDismissedFunc: () => userSettingViewProvider.changeEndDrawerStatus(SkillEndDrawerType.close),
      );
    } else if (endDrawer == SkillEndDrawerType.wantSkill) {
      endDrawerWidget = SkillChoiceSettingPage(
        skillType: SkillEndDrawerType.wantSkill,
        onDismissedFunc: () => userSettingViewProvider.changeEndDrawerStatus(SkillEndDrawerType.close),
      );
    }

    return endDrawerWidget;
  });
}
