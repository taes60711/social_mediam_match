import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/members_filter.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/user_detail.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/models/user_model.dart';
import '../../../states/skill_exchange_state.dart';

class SkillExChangePage extends StatelessWidget {
  final LoginUser? userData;
  const SkillExChangePage({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    List<LoginUser> allUserData = Provider.of<SkillExChangeState>(context).allUserData;
    GlobalKey<ScaffoldState> globalKey = context.select((SkillExChangeState value) => value.globalKey);
    List<String> filterSkill = context.select((SkillExChangeState value) => value.filterSkill);
    bool isLoading = context.select((SkillExChangeState value) => value.isLoading);
    SkillExChangeState skillExChangeState = context.read<SkillExChangeState>();
    String endDrawerType = context.select((SkillExChangeState value) => value.endDrawerType);

    return StatefulWrapper(
      onInit: () {
        Provider.of<SkillExChangeState>(context, listen: false)
            .getAllUserData(userData!.uid, filterSkill: filterSkill, isFirstSearch: true);
      },
      child: Scaffold(
        key: globalKey,
        endDrawer: endDrawerType == "filter"
            ? MembersFilter(
                globalKey: globalKey,
                userData: userData,
              )
            : UserDetail(
                globalKey: globalKey,
              ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  skillExChangeState.openDrawer("filter");
                },
                icon: Icon(Icons.dehaze_rounded),
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    final before = scrollNotification.metrics.extentBefore;
                    final max = scrollNotification.metrics.maxScrollExtent;
                    if (before == max && !isLoading) {
                      Provider.of<SkillExChangeState>(context, listen: false)
                          .getAllUserData(userData!.uid, filterSkill: filterSkill, isFirstSearch: false);
                    }
                  }
                  return false;
                },
                child: ListView.builder(
                    itemCount: allUserData.length,
                    itemBuilder: (context, index) {
                      List<String> skills = allUserData[index].mainSkills!.map((e) => e.name).toList();
                      List<String> wantSkills = allUserData[index].wantSkills!.map((e) => e.name).toList();
                      return Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            inspect(allUserData[index]);
                            skillExChangeState.openDrawer("userDetail");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(255, 218, 219, 219),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 8),
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                      Text(allUserData[index].email),
                                    ],
                                  ),
                                  Text("最後登入時間: ${allUserData[index].lastLogin}"),
                                  Text(skills.isNotEmpty ? "擅長的技能 : $skills" : "擅長的技能 : "),
                                  Text(wantSkills.isNotEmpty ? "想學的技能 : $wantSkills" : "想學的技能 : "),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
