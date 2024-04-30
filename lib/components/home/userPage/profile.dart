import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/userPage/skill_choice.dart';
import 'package:social_mediam_match/components/strings/userPage/profie_string.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/title_input.dart';
import 'package:social_mediam_match/states/user_setting_state.dart';
import 'package:social_mediam_match/states/user_state.dart';
import '../../../global.dart';
import '../../../models/skill_model.dart';
import '../../../models/user_model.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../strings/userPage/user_page_string.dart';
import '../../utilities/skill_list_view.dart';
import '../../utilities/stateful_wrapper.dart';
import '../../utilities/user_icon.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    UserSettingState userSettingState = context.read<UserSettingState>();
    UserState userState = context.read<UserState>();
    LoginUser userData = ModalRoute.of(context)!.settings.arguments as LoginUser;
    TextEditingController nameInput = context.select((UserSettingState value) => value.nameInput);
    TextEditingController jobInput = context.select((UserSettingState value) => value.jobInput);
    TextEditingController introductionInput = context.select((UserSettingState value) => value.introductionInput);
    String base64Img = context.select((UserSettingState value) => value.base64Img);
    bool isFirst = context.select((UserSettingState value) => value.isFirst);
    GlobalKey<ScaffoldState> key = context.select((UserSettingState value) => value.key);
    String type = context.select((UserSettingState value) => value.type);

    //先暫時沒整理
    List<SkillModel> forntSkillItems = context.watch<UserSettingState>().forntSkillList;
    List<SkillModel> backEndSkillItems = context.watch<UserSettingState>().backEndSkillList;
    List<SkillModel> iotSkillItems = context.watch<UserSettingState>().iotSkillList;
    List<SkillModel> otherSkillItems = context.watch<UserSettingState>().otherSkillList;

    List<SkillModel> allSkillItems = [];
    List<SkillModel> allWantSkillItems = [];
    forntSkillItems.forEach((element) {
      if (element.skillHave.level > 0) allSkillItems = [...allSkillItems, element];
      if (element.skillWant.level > 0) allWantSkillItems = [...allWantSkillItems, element];
    });
    backEndSkillItems.forEach((element) {
      if (element.skillHave.level > 0) allSkillItems = [...allSkillItems, element];
      if (element.skillWant.level > 0) allWantSkillItems = [...allWantSkillItems, element];
    });
    iotSkillItems.forEach((element) {
      if (element.skillHave.level > 0) allSkillItems = [...allSkillItems, element];
      if (element.skillWant.level > 0) allWantSkillItems = [...allWantSkillItems, element];
    });
    otherSkillItems.forEach((element) {
      if (element.skillHave.level > 0) allSkillItems = [...allSkillItems, element];
      if (element.skillWant.level > 0) allWantSkillItems = [...allWantSkillItems, element];
    });
    //

    Future<void> exitCheck() {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('確認'),
            content: const Text('有資料正在編輯,確定要離開嗎?'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('確定'),
                onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                },
              ),
              ElevatedButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

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

    return StatefulWrapper(
      onInit: () {
        userSettingState.userDataInsertToViewValue(userData);
        userSettingState.getSkillListData(userData: userData);
      },
      child: isFirst
          ? const Loading()
          : Scaffold(
              resizeToAvoidBottomInset: false,
              key: key,
              endDrawer: SkillChoice(
                userSettingState: userSettingState,
                forntSkillItems: forntSkillItems,
                backEndSkillItems: backEndSkillItems,
                iotSkillItems: iotSkillItems,
                otherSkillItems: otherSkillItems,
                allSkillItems: allSkillItems,
                allWantSkillItems: allWantSkillItems,
                type: type,
              ),
              body: BackgroundWidget(
                isSafeArea: true,
                child: FittedBox(
                  child: Column(
                    children: [
                      Text(pageTitle),
                      SizedBox(
                        width: ScreenSize().width,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () {
                              inspect(userData);
                              bool isChange = userSettingState.isProfileChange(userData, base64Img, nameInput.text, jobInput.text,
                                  introductionInput.text, allSkillItems, allWantSkillItems);
                              if (isChange) {
                                exitCheck();
                              } else {
                                Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                              }
                            },
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                        ),
                      ),
                      UserIcon(
                        iconSize: 120,
                        image: base64Img,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 150,
                        child: CustomButton(
                          title: "image Picker",
                          titleColor: normalTextColor,
                          backgroundColor: normalBgColor,
                          onPress: () async {
                            await userSettingState.imageChange();
                          },
                        ),
                      ),
                      TitleInput(title: "用戶名", textController: nameInput),
                      TitleInput(title: "職業", textController: jobInput),
                      const SizedBox(height: 15),
                      skillTitle(type: "have"),
                      skillTitle(type: "want"),
                      TitleInput(isMulti: true, title: "自我介紹", textController: introductionInput),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomButton(
                          title: "更新",
                          titleColor: normalTextColor,
                          backgroundColor: normalBgColor,
                          onPress: () async {
                            UpdateUser updateUserData = userSettingState.reformatData(
                              userData.uid,
                              base64Img,
                              nameInput.text,
                              jobInput.text,
                              introductionInput.text,
                              forntSkillItems,
                              iotSkillItems,
                              backEndSkillItems,
                              otherSkillItems,
                            );

                            bool isSucess = await userState.updateProfile(userData.uid, updateUserData);

                            if (isSucess) {
                              Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
