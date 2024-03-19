import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/strings/userPage/profie_string.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/states/user_setting_state.dart';
import 'package:social_mediam_match/states/user_state.dart';
import '../../../global.dart';
import '../../../models/skill_model.dart';
import '../../../models/user_model.dart';
import '../../utilities/stateful_wrapper.dart';

class SkillListWidget extends StatelessWidget {
  LoginUser userData;
  String base64Img;
  TextEditingController nameInput;
  TextEditingController introductionInput;
  SkillListWidget(
      {required this.userData, required this.base64Img, required this.nameInput, required this.introductionInput, super.key});

  @override
  Widget build(BuildContext context) {
    UserState userFuture = context.read<UserState>();
    UserSettingState userSettingFuture = context.read<UserSettingState>();
    bool isFirst = context.select((UserSettingState value) => value.isFirst);
    List<SkillModel> forntSkillItems = context.watch<UserSettingState>().forntSkillList;
    List<SkillModel> iotSkillItems = context.watch<UserSettingState>().iotSkillList;
    List<SkillModel> backEndSkillItems = context.watch<UserSettingState>().backEndSkillList;
    List<SkillModel> otherSkillItems = context.watch<UserSettingState>().otherSkillList;

    Widget ExpansionWidget(String category, List<SkillModel> list, String type) {
      Widget component = ExpansionTile(
        title: Text(category),
        leading: const Icon(Icons.align_horizontal_left),
        children: list.map((e) {
          ProfileSkill skillInfoItem = type == "have" ? e.skillHave : e.skillWant;
          String? selectedItem = "${skillInfoItem.skillInfo.level}";
          return Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(skillInfoItem.skillInfo.name),
                ),
                Switch(
                    value: skillInfoItem.ishave,
                    onChanged: (value) {
                      userSettingFuture.checkOnChange(skillInfoItem, type);
                    }),
                Text(level),
                DropdownButton(
                  value: selectedItem,
                  items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (value) {
                    userSettingFuture.checkOnChange(skillInfoItem, "level", choicedLevel: value);
                  },
                ),
              ],
            ),
          );
        }).toList(),
      );

      return component;
    }

    return StatefulWrapper(
      onInit: () {
        userSettingFuture.getPageAllData(userData);
      },
      child: isFirst
          ? Loading()
          : ListView(
              children: [
                ExpansionTile(
                  title: Text(ItemTitles.Skill.value),
                  leading: const Icon(Icons.build_sharp),
                  children: [
                    ExpansionWidget(SkillType.forntend.value, forntSkillItems, "have"),
                    ExpansionWidget(SkillType.backend.value, backEndSkillItems, "have"),
                    ExpansionWidget(SkillType.iot.value, iotSkillItems, "have"),
                    ExpansionWidget(SkillType.other.value, otherSkillItems, "have"),
                  ],
                ),
                ExpansionTile(
                  title: Text(ItemTitles.wantSkill.value),
                  leading: const Icon(Icons.build_sharp),
                  children: [
                    ExpansionWidget(SkillType.forntend.value, forntSkillItems, "want"),
                    ExpansionWidget(SkillType.backend.value, backEndSkillItems, "want"),
                    ExpansionWidget(SkillType.iot.value, iotSkillItems, "want"),
                    ExpansionWidget(SkillType.other.value, otherSkillItems, "want"),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    UpdateUser updateUserData = userSettingFuture.reformatData(
                      userData.uid,
                      base64Img,
                      nameInput.text,
                      introductionInput.text,
                      forntSkillItems,
                      iotSkillItems,
                      backEndSkillItems,
                      otherSkillItems,
                    );
                    userFuture.updateProfile(userData.uid, updateUserData);
                  },
                  child: Text(updateButtonTitle),
                ),
              ],
            ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    UserSettingState userSettingFuture = context.read<UserSettingState>();
    LoginUser userData = ModalRoute.of(context)!.settings.arguments as LoginUser;
    TextEditingController nameInput = context.select((UserSettingState value) => value.nameInput);
    TextEditingController introductionInput = context.select((UserSettingState value) => value.introductionInput);
    String base64Img = context.select((UserSettingState value) => value.base64Img);

    return StatefulWrapper(
      onInit: () {
        context.read<UserSettingState>().getuserImg(userData);
      },
      child: Scaffold(
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
                  width: 120,
                  height: 120,
                  child: base64Img != ""
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.memory(
                            const Base64Decoder().convert(base64Img),
                          ),
                        )
                      : Container(),
                ),
                ElevatedButton(
                  onPressed: () async {
                    userSettingFuture.imageChange();
                  },
                  child: const Text("image Picker"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                Expanded(
                  child: ChangeNotifierProvider(
                    create: (_) => UserSettingState(),
                    child: SkillListWidget(
                      userData: userData,
                      base64Img: base64Img,
                      nameInput: nameInput,
                      introductionInput: introductionInput,
                    ),
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
