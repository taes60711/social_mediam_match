import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/fit_widget.dart';
import 'package:social_mediam_match/provider/home/user_setting_view_model.dart';
import 'package:social_mediam_match/provider/home/user_setting_view_provider.dart';

import '../../account/skill_bar.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../strings/userPage/user_page_string.dart';
import '../../utilities/background_widget.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/endDrawers/skill_setting_end_drawer.dart';
import '../../utilities/stateful_wrapper.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/label_input.dart';
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
        skillSettingEndDrawer(),
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
      LabelInput(
        title: StepTwoPage.nameInputTitle,
        textController: userSettingViewProvider.nameInput,
      ),

      ///job
      LabelInput(
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
          String displayText = context.select((UserSettingViewProvider value) => value.introductionInput.text);
          return MultiLabelInput(
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
        child: TextBtn(
          title: ProfileString().updateButtonText,
          titleColor: normalTextColor,
          btnColor: normalBgColor,
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
    child: TextBtn(
      btnWidth: 150,
      title: ProfileString().imgPickerButtonText,
      titleColor: normalTextColor,
      btnColor: googleColor,
      onPress: () async {
        await userSettingViewProvider.imageChange();
      },
    ),
  );
}
