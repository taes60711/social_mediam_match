import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/strings/profie_string.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/states/user_setting_state.dart';
import 'package:social_mediam_match/states/user_state.dart';
import '../../../global.dart';
import '../../../models/user_model.dart';
import '../../utilities/stateful_wrapper.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    UserState userFuture = context.read<UserState>();
    UserSettingState userSettingFuture = context.read<UserSettingState>();
    bool isFirst = context.select((UserSettingState value) => value.isFirst);
    LoginUser userData = ModalRoute.of(context)!.settings.arguments as LoginUser;

    List<SkillModel> forntSkillItems = context.watch<UserSettingState>().forntSkillList;
    List<SkillModel> iotSkillItems = context.watch<UserSettingState>().iotSkillList;
    List<SkillModel> backEndSkillItems = context.watch<UserSettingState>().backEndSkillList;
    List<SkillModel> otherSkillItems = context.watch<UserSettingState>().otherSkillList;

    TextEditingController nameInput = TextEditingController()..text = userData.name ?? "";
    TextEditingController introductionInput = TextEditingController()
      ..text = userData.introduction ?? "";

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

    return isFirst
        ? StatefulWrapper(
            onInit: () {
              userSettingFuture.getPageAllData(userData);
            },
            child: SizedBox(
              width: ScreenSize().width,
              child: const Loading(),
            ))
        : Scaffold(
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
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: nameInput,
                      decoration: const InputDecoration(
                        labelText: "用户名",
                        hintText: "用户名",
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("自我介紹"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      minLines: 3,
                      maxLines: 6,
                      controller: introductionInput,
                      decoration: const InputDecoration(
                        hintText: 'Write a message',
                        filled: true,
                      ),
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                  Expanded(
                      child: ListView(
                    children: [
                      ExpansionTile(
                          title: const Text('擅長的技能'),
                          leading: const Icon(Icons.build_sharp),
                          children: [
                            ExpansionWidget(SkillType.forntend.value, forntSkillItems, "have"),
                            ExpansionWidget(SkillType.backend.value, backEndSkillItems, "have"),
                            ExpansionWidget(SkillType.iot.value, iotSkillItems, "have"),
                            ExpansionWidget(SkillType.other.value, otherSkillItems, "have"),
                          ]),
                      ExpansionTile(
                        title: const Text('想要學的技能'),
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
                  ))
                ],
              ),
            )),
          );
  }
}
