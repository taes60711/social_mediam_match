import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/states/user_setting_state.dart';
import 'package:social_mediam_match/states/user_state.dart';
import '../../../global.dart';
import '../../../models/user_model.dart';
import '../../utilities/Stateful_wrapper.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    UserState userFuture = context.read<UserState>();
    UserSettingState userSettingFuture = context.read<UserSettingState>();
    bool isFirst = context.select((UserSettingState value) => value.isFirst);
    LoginUser userData = ModalRoute.of(context)!.settings.arguments as LoginUser;

    List<SkillModel> forntSkillItems = context.watch<UserSettingState>().forntSkillList;
    List<SkillModel> backEndSkillItems = context.watch<UserSettingState>().backEndSkillList;
    List<SkillModel> otherSkillItems = context.watch<UserSettingState>().otherSkillList;
    TextEditingController nameInput = TextEditingController()..text = userData.name ?? "";
    TextEditingController introductionInput = TextEditingController()..text = userData.introduction ?? "";

    var items = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
    ];

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
                  Text("個人資料"),
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
                      ExpansionTile(title: const Text('擅長的技能'), leading: const Icon(Icons.build_sharp), children: [
                        ExpansionTile(
                          title: const Text('網頁'),
                          leading: const Icon(Icons.align_horizontal_left),
                          children: forntSkillItems.map((e) {
                            String? selectedItem = "${e.skillInfo.level}";
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(e.skillInfo.name),
                                  ),
                                  Switch(
                                      value: e.haveSkill,
                                      onChanged: (value) {
                                        userSettingFuture.checkOnChange(e.skillInfo.name, "web_have");
                                      }),
                                  const Text("程度 :"),
                                  DropdownButton(
                                    value: selectedItem,
                                    items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                    onChanged: (value) {
                                      userSettingFuture.skillLevelOnchange(e.skillInfo.name, value ?? "0", "web_have");
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        ExpansionTile(
                          title: const Text('後端'),
                          leading: const Icon(Icons.align_horizontal_left),
                          children: backEndSkillItems.map((e) {
                            String? selectedItem = "${e.skillInfo.level}";
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(e.skillInfo.name),
                                  ),
                                  Switch(
                                      value: e.haveSkill,
                                      onChanged: (value) {
                                        userSettingFuture.checkOnChange(e.skillInfo.name, "backend_have");
                                      }),
                                  const Text("程度 :"),
                                  DropdownButton(
                                    value: selectedItem,
                                    items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                    onChanged: (value) {
                                      userSettingFuture.skillLevelOnchange(e.skillInfo.name, value ?? "0", "backend_have");
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        ExpansionTile(
                          title: const Text('其他'),
                          leading: const Icon(Icons.align_horizontal_left),
                          children: otherSkillItems.map((e) {
                            String? selectedItem = "${e.skillInfo.level}";
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(e.skillInfo.name),
                                  ),
                                  Switch(
                                      value: e.haveSkill,
                                      onChanged: (value) {
                                        userSettingFuture.checkOnChange(e.skillInfo.name, "other_have");
                                      }),
                                  const Text("程度 :"),
                                  DropdownButton(
                                    value: selectedItem,
                                    items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                    onChanged: (value) {
                                      userSettingFuture.skillLevelOnchange(e.skillInfo.name, value ?? "0", "other_have");
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ]),
                      ExpansionTile(
                        title: const Text('想要學的技能'),
                        leading: const Icon(Icons.build_sharp),
                        children: [
                          ExpansionTile(
                            title: const Text('網頁'),
                            leading: const Icon(Icons.align_horizontal_left),
                            children: forntSkillItems.map((e) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(e.skillInfo.name),
                                    ),
                                    Switch(
                                        value: e.wantSkill,
                                        onChanged: (value) {
                                          userSettingFuture.checkOnChange(e.skillInfo.name, "web_want");
                                        }),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          ExpansionTile(
                            title: const Text('後端'),
                            leading: const Icon(Icons.align_horizontal_left),
                            children: backEndSkillItems.map((e) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(e.skillInfo.name),
                                    ),
                                    Switch(
                                        value: e.wantSkill,
                                        onChanged: (value) {
                                          userSettingFuture.checkOnChange(e.skillInfo.name, "backend_want");
                                        }),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          ExpansionTile(
                            title: const Text('其他'),
                            leading: const Icon(Icons.align_horizontal_left),
                            children: otherSkillItems.map((e) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(e.skillInfo.name),
                                    ),
                                    Switch(
                                        value: e.wantSkill,
                                        onChanged: (value) {
                                          userSettingFuture.checkOnChange(e.skillInfo.name, "other_want");
                                        }),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          UpdateUser updateUserData = userSettingFuture.reformatData(userData.uid, nameInput.text,
                              introductionInput.text, forntSkillItems, backEndSkillItems, otherSkillItems);

                          userFuture.updateProfile(userData.uid, updateUserData);
                        },
                        child: const Text("更新"),
                      ),
                    ],
                  ))
                ],
              ),
            )),
          );
  }
}
