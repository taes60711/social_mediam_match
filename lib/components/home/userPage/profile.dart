import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/userPage/skill_choice.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/title_input.dart';
import 'package:social_mediam_match/states/user_setting_provider.dart';

import '../../../models/skill_model.dart';
import '../../../models/user_model.dart';

import '../../../provider/account/user_provider.dart';
import '../../../enum/route_path.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../strings/userPage/user_page_string.dart';
import '../../utilities/skill_list_view.dart';
import '../../utilities/stateful_wrapper.dart';
import '../../utilities/user_icon.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    UserSettingProvider userSettingProvider = context.read<UserSettingProvider>();
    UserProvider userProvider = context.read<UserProvider>();
    LoginUser userData = ModalRoute.of(context)!.settings.arguments as LoginUser;
    TextEditingController nameInput = context.select((UserSettingProvider value) => value.nameInput);
    TextEditingController jobInput = context.select((UserSettingProvider value) => value.jobInput);
    TextEditingController introductionInput = context.select((UserSettingProvider value) => value.introductionInput);
    String base64Img = context.select((UserSettingProvider value) => value.base64Img);
    bool isFirst = context.select((UserSettingProvider value) => value.isFirst);
    GlobalKey<ScaffoldState> key = context.select((UserSettingProvider value) => value.key);
    String type = context.select((UserSettingProvider value) => value.type);

    //先暫時沒整理
    List<SkillModel> forntSkillItems = context.watch<UserSettingProvider>().forntSkillList;
    List<SkillModel> backEndSkillItems = context.watch<UserSettingProvider>().backEndSkillList;
    List<SkillModel> iotSkillItems = context.watch<UserSettingProvider>().iotSkillList;
    List<SkillModel> otherSkillItems = context.watch<UserSettingProvider>().otherSkillList;

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

    //編集したらポップ（編集したら画面を離れる前に確認）
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

    //パックボタン（画面を離れるよう）
    Widget backButton = Container(
      margin: EdgeInsets.only(left: ScreenSize.width * 0.03),
      width: ScreenSize.width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: ScreenSize.width * 0.3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  inspect(userData);
                  bool isChange = userSettingProvider.isProfileChange(userData, base64Img, nameInput.text, jobInput.text,
                      introductionInput.text, allSkillItems, allWantSkillItems);
                  if (isChange) {
                    exitCheck();
                  } else {
                    Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                  }
                },
                child: const Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
          //タイトル
          SizedBox(
            width: ScreenSize.width * 0.34,
            child: Align(
              alignment: Alignment.center,
              child: Text(ProfileString().title),
            ),
          ),
          //更新ボタン
          SizedBox(
            width: ScreenSize.width * 0.3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Material(
                // color: normalBgColor,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () async {
                    UpdateUser updateUserData = userSettingProvider.reformatData(
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

                    bool isSucess = await userProvider.updateProfile(userData.uid, updateUserData);

                    if (isSucess) {
                      Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    child: Text(
                      ProfileString().updateButtonText,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );

    //スキルタイトルボタン、押したらスキル選択ページに遷移する
    skillTitle({required String type}) {
      List<SkillModel> skillItems = type == "have" ? allSkillItems : allWantSkillItems;
      String title = type == "have" ? StepThirdPage.haveSkillText : StepThirdPage.wantSkillText;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: GestureDetector(
          onTap: () {
            print(type);
            userSettingProvider.openSkillselectPage(type);
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
                    "(${skillItems.length} / 5)",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: ScreenSize.width,
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
        userSettingProvider.userDataInsertToViewValue(userData);
        userSettingProvider.getSkillListData(userData: userData);
      },
      child: isFirst
          ? const Loading()
          : Scaffold(
              resizeToAvoidBottomInset: false,
              key: key,
              endDrawer: SkillChoice(
                userSettingProvider: userSettingProvider,
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
                child: Column(
                  children: [
                    backButton,
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: ScreenSize.safeHeight * 0.025),
                      child: SizedBox(
                        height: ScreenSize.safeHeight * 0.15,
                        child: FittedBox(
                          child: Column(
                            children: [
                              UserIcon(iconSize: 120, image: base64Img),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenSize.safeHeight * 0.05,
                      child: FittedBox(
                        child: Column(
                          children: [
                            SizedBox(
                              width: 150,
                              child: CustomButton(
                                title: ProfileString().imgPickerButtonText,
                                titleColor: normalTextColor,
                                backgroundColor: googleColor,
                                onPress: () async {
                                  await userSettingProvider.imageChange();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenSize.safeHeight * 0.65,
                      child: FittedBox(
                        child: Column(
                          children: [
                            TitleInput(title: ProfileString().nameInputTitle, textController: nameInput),
                            TitleInput(title: ProfileString().jobInputTitle, textController: jobInput),
                            const SizedBox(height: 15),
                            skillTitle(type: "have"),
                            skillTitle(type: "want"),
                            Builder(
                              builder: (context) {
                                return MultiTitleInput(
                                  title: StepThirdPage.introInputTitle,
                                  textController: userSettingProvider.introductionInput,
                                  displayText: userSettingProvider.introductionInput.text,
                                  multiOnChange: (newValue) {
                                    userSettingProvider.inputOnChange(newValue);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
