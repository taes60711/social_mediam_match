import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/userPage/skill_choice.dart';
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

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  double keboardHeight = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        _scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        print("關閉鍵盤");
      } else {
        double bottom = MediaQuery.of(context).viewInsets.bottom;
        keboardHeight = max(keboardHeight, bottom);
        _scrollController.animateTo(200, duration: Duration(milliseconds: 500), curve: Curves.ease);

        print("顯示鍵盤 ${keboardHeight}");
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
      margin: EdgeInsets.only(left: ScreenSize().width * 0.03),
      width: ScreenSize().width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: ScreenSize().width * 0.3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  inspect(userData);
                  bool isChange = userSettingState.isProfileChange(userData, base64Img, nameInput.text, jobInput.text,
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
            width: ScreenSize().width * 0.34,
            child: Align(
              alignment: Alignment.center,
              child: Text(ProfileString().title),
            ),
          ),
          //更新ボタン
          SizedBox(
            width: ScreenSize().width * 0.3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Material(
                // color: normalBgColor,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () async {
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
                    "(${skillItems.length} / 5)",
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
          ? ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              controller: _scrollController,
              children: const [Loading()],
            )
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
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _scrollController,
                  children: [
                    backButton,
                    SizedBox(
                      height: ScreenSize().safeheight,
                      child: FittedBox(
                        child: Column(
                          children: [
                            UserIcon(iconSize: 120, image: base64Img),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 150,
                              child: CustomButton(
                                title: ProfileString().imgPickerButtonText,
                                titleColor: normalTextColor,
                                backgroundColor: normalBgColor,
                                onPress: () async {
                                  await userSettingState.imageChange();
                                },
                              ),
                            ),
                            TitleInput(title: ProfileString().nameInputTitle, textController: nameInput),
                            TitleInput(title: ProfileString().jobInputTitle, textController: jobInput),
                            const SizedBox(height: 15),
                            skillTitle(type: "have"),
                            skillTitle(type: "want"),
                            TitleInput(
                                isMulti: true, title: ProfileString().introductionInputTitle, textController: introductionInput),
                          ],
                        ),
                      ),
                    ),
                    Container(height: keboardHeight)
                  ],
                ),
              ),
            ),
    );
  }
}
