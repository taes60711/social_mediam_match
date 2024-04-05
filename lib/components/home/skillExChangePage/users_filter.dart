import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

import '../../../global.dart';
import '../../../models/user_model.dart';
import '../../../states/skill_exchange_state.dart';

class UsersFilter extends StatelessWidget {
  final GlobalKey<ScaffoldState> globalKey;
  final LoginUser? userData;
  const UsersFilter({super.key, required this.globalKey, this.userData});

  @override
  Widget build(BuildContext context) {
    SkillExChangeState skillExChangeFuture = context.read<SkillExChangeState>();
    List<Map<String, dynamic>> forntSkillList = context.watch<SkillExChangeState>().forntSkillList;
    List<Map<String, dynamic>> backEndSkillList = context.watch<SkillExChangeState>().backEndSkillList;
    List<Map<String, dynamic>> iotSkillList = context.watch<SkillExChangeState>().iotSkillList;
    List<Map<String, dynamic>> otherSkillList = context.watch<SkillExChangeState>().otherSkillList;
    bool isFirst = context.select((SkillExChangeState value) => value.isFirst);

    return isFirst
        ? StatefulWrapper(
            onInit: () {
              skillExChangeFuture.getSkillList();
            },
            child: const Loading(),
          )
        : SizedBox(
            width: ScreenSize().width,
            child: Drawer(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () async {
                        print("Drawer Close");
                        globalKey.currentState!.closeEndDrawer();
                      },
                      icon: const Icon(Icons.arrow_back_ios_sharp),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ExpansionTile(
                          title: Text(SkillType.forntend.value),
                          leading: const Icon(Icons.align_horizontal_left),
                          children: forntSkillList.map((e) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  Expanded(child: Text(e['name'])),
                                  Switch(
                                      value: e['bool'],
                                      onChanged: (value) {
                                        skillExChangeFuture.filterOnChange(forntSkillList, e['name']);
                                      }),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        ExpansionTile(
                          title: Text(SkillType.backend.value),
                          leading: const Icon(Icons.align_horizontal_left),
                          children: backEndSkillList.map((e) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  Expanded(child: Text(e['name'])),
                                  Switch(
                                      value: e['bool'],
                                      onChanged: (value) {
                                        skillExChangeFuture.filterOnChange(backEndSkillList, e['name']);
                                      }),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        ExpansionTile(
                          title: Text(SkillType.iot.value),
                          leading: const Icon(Icons.align_horizontal_left),
                          children: iotSkillList.map((e) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  Expanded(child: Text(e['name'])),
                                  Switch(
                                      value: e['bool'],
                                      onChanged: (value) {
                                        skillExChangeFuture.filterOnChange(iotSkillList, e['name']);
                                      }),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        ExpansionTile(
                          title: Text(SkillType.other.value),
                          leading: const Icon(Icons.align_horizontal_left),
                          children: otherSkillList.map((e) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  Expanded(child: Text(e['name'])),
                                  Switch(
                                      value: e['bool'],
                                      onChanged: (value) {
                                        skillExChangeFuture.filterOnChange(otherSkillList, e['name']);
                                      }),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await skillExChangeFuture.filterButtonOnClick(
                        userData!.uid,
                        forntSkillList,
                        backEndSkillList,
                        iotSkillList,
                        otherSkillList,
                      );
                    },
                    child: Text("篩選"),
                  ),
                ],
              ),
            ),
          );
  }
}
