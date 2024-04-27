import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/userPage/skill_choice.dart';
import 'package:social_mediam_match/components/strings/userPage/profie_string.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/states/user_setting_state.dart';
import 'package:social_mediam_match/states/user_state.dart';
import '../../../global.dart';
import '../../../models/skill_model.dart';
import '../../../models/user_model.dart';
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
              body: SafeArea(
                child: SizedBox(
                  width: ScreenSize().width,
                  child: Column(
                    children: [
                      Text(pageTitle),
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () {
                            inspect(userData);
                            print(jobInput.text);
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
                      UserIcon(
                        iconSize: 120,
                        image: base64Img,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await userSettingState.imageChange();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: const Color.fromARGB(221, 209, 104, 104),
                          child: const Text("image Picker"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        child: TextField(
                          controller: nameInput,
                          decoration: InputDecoration(
                            labelText: ItemTitles.username.value,
                            hintText: ItemTitles.username.hintText,
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        child: TextField(
                          controller: jobInput,
                          decoration: InputDecoration(
                            labelText: ItemTitles.username.value,
                            hintText: ItemTitles.username.hintText,
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            userSettingState.openSkillselectPage("have");
                          },
                          child: Row(
                            children: [
                              Text(skillText),
                              const Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenSize().width,
                        child: SkillListView(
                          skillList: allSkillItems.map((e) => e.skillHave).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            userSettingState.openSkillselectPage("want");
                          },
                          child: Row(
                            children: [
                              Text(wantSkillText),
                              const Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenSize().width,
                        child: SkillListView(
                          skillList: allWantSkillItems.map((e) => e.skillWant).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(ItemTitles.selfIntroduction.value),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          minLines: 3,
                          maxLines: 6,
                          controller: introductionInput,
                          decoration: InputDecoration(
                            hintText: ItemTitles.selfIntroduction.hintText,
                            filled: true,
                          ),
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
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
                        child: Text(updateButtonTitle),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
