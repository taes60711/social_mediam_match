import 'dart:convert';
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
import '../../utilities/stateful_wrapper.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    UserSettingState userSettingState = context.read<UserSettingState>();
    UserState userState = context.read<UserState>();
    LoginUser userData = ModalRoute.of(context)!.settings.arguments as LoginUser;
    TextEditingController nameInput = context.select((UserSettingState value) => value.nameInput);
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
    return StatefulWrapper(
      onInit: () {
        userSettingState.userDataInsertToViewValue(userData);
        userSettingState.getSkillListData(userData);
      },
      child: isFirst
          ? const Loading()
          : Scaffold(
              key: key,
              endDrawer: SkillChoice(
                userSettingState: userSettingState,
                forntSkillItems: forntSkillItems,
                backEndSkillItems: backEndSkillItems,
                iotSkillItems: iotSkillItems,
                otherSkillItems: otherSkillItems,
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
                            Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                          },
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: base64Img != ""
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.memory(
                                  const Base64Decoder().convert(base64Img),
                                ),
                              )
                            : Container(),
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
                        padding: const EdgeInsets.only(left: 8, bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            userSettingState.openSkillselectPage("have");
                            key.currentState!.openEndDrawer();
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
                        child: Wrap(
                          runSpacing: 5,
                          spacing: 5,
                          children: allSkillItems
                              .map((e) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color.fromARGB(255, 233, 231, 231),
                                    ),
                                    child: Text(e.skillHave.name),
                                  ))
                              .toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            userSettingState.openSkillselectPage("want");
                            key.currentState!.openEndDrawer();
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
                        child: Wrap(
                          runSpacing: 5,
                          spacing: 5,
                          children: allWantSkillItems
                              .map((e) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color.fromARGB(255, 233, 231, 231),
                                    ),
                                    child: Text(e.skillWant.name),
                                  ))
                              .toList(),
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
