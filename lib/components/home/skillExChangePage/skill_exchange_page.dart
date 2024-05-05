import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/users_filter.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/user_detail.dart';
import 'package:social_mediam_match/components/strings/userPage/user_page_string.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/models/user_model.dart';
import '../../../states/skill_exchange_state.dart';
import '../../utilities/skill_list_view.dart';
import '../../utilities/user_icon.dart';

class SkillExChangePage extends StatelessWidget {
  final LoginUser userData;
  final VoidCallback gotoFriendPage;
  const SkillExChangePage({super.key, required this.userData, required this.gotoFriendPage});

  @override
  Widget build(BuildContext context) {
    List<LoginUser> allUserData = context.watch<SkillExChangeState>().allUserData;
    GlobalKey<ScaffoldState> globalKey = context.select((SkillExChangeState value) => value.globalKey);
    List<String> filterSkill = context.select((SkillExChangeState value) => value.filterSkill);
    bool isAddDataLoading = context.select((SkillExChangeState value) => value.isAddDataLoading);
    bool isFirstLoading = context.select((SkillExChangeState value) => value.isFirstLoading);
    bool isReLoading = context.select((SkillExChangeState value) => value.isReLoading);
    SkillExChangeState skillExChangeState = context.read<SkillExChangeState>();
    String endDrawerType = context.select((SkillExChangeState value) => value.endDrawerType);
    LoginUser? otherUser = context.select((SkillExChangeState value) => value.otherUser);
    return StatefulWrapper(
      onInit: () {
        skillExChangeState.getAllUserData(userUid: userData.uid, filterSkill: filterSkill, searchType: "First");
      },
      child: isFirstLoading
          ? const Loading()
          : Scaffold(
              key: globalKey,
              endDrawer: endDrawerType == "filter"
                  ? UsersFilter(
                      globalKey: globalKey,
                      userData: userData,
                    )
                  : UserDetail(
                      globalKey: globalKey,
                      userData: userData,
                      otherUser: otherUser,
                      gotoFriendPage: gotoFriendPage,
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
                  isReLoading ? Loading() : Container(),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollNotification) {
                        if (scrollNotification is ScrollUpdateNotification) {
                          final scrollPosition = scrollNotification.metrics.pixels;
                          final max = scrollNotification.metrics.maxScrollExtent;
                          if (!isAddDataLoading && !isReLoading) {
                            if (scrollPosition > max && !isAddDataLoading) {
                              skillExChangeState.addData();
                            } else if (scrollPosition < 0 && !isReLoading) {
                              skillExChangeState.reLoadingPage();
                            }
                          }
                        }
                        if (scrollNotification is ScrollEndNotification) {
                          if (isAddDataLoading) {
                            skillExChangeState.getAllUserData(
                                userUid: userData.uid, filterSkill: filterSkill, searchType: "AddData");
                          } else if (isReLoading) {
                            skillExChangeState.getAllUserData(
                                userUid: userData.uid, filterSkill: filterSkill, searchType: "Reload");
                          }
                        }
                        return false;
                      },
                      child: ListView.builder(
                          itemCount: allUserData.length,
                          itemBuilder: (context, index) {
                            Widget listComponent;
                            if (index != allUserData.length - 1) {
                              listComponent = Padding(
                                padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    inspect(allUserData[index]);
                                    skillExChangeState.openDrawer("userDetail", otherUser: allUserData[index]);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        allUserData[index].image != null
                                            ? SizedBox(
                                                width: 65,
                                                height: 100,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(5),
                                                  child: Image.memory(
                                                    const Base64Decoder().convert(allUserData[index].image ?? ""),
                                                    gaplessPlayback: true,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ))
                                            : Container(
                                                width: 65,
                                                height: 100,
                                                decoration:
                                                    BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.black38),
                                              ),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: ScreenSize().width - 100,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(allUserData[index].email, style: TextStyle(fontSize: 14)),
                                                        Text(
                                                          allUserData[index].job ?? "無",
                                                          style: TextStyle(color: Colors.grey, fontSize: 13),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    "${allUserData[index].lastLogin}天前",
                                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                              allUserData[index].introduction != ""
                                                  ? Text("${allUserData[index].introduction}",
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(fontSize: 13, color: normalBgColor2))
                                                  : Container(),
                                              Text(skillText, style: TextStyle(fontSize: 13)),
                                              SkillListView(
                                                fontSize: 11,
                                                skillList: allUserData[index].mainSkills ?? [],
                                              ),
                                              Text(wantSkillText, style: TextStyle(fontSize: 13)),
                                              SkillListView(
                                                fontSize: 11,
                                                skillList: allUserData[index].wantSkills ?? [],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              listComponent = Column(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        decoration:
                                            BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                width: 65,
                                                height: 90,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Image.memory(
                                                    const Base64Decoder().convert(allUserData[index].image ?? ""),
                                                    gaplessPlayback: true,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )),
                                            SizedBox(width: 10),
                                            SizedBox(
                                              width: ScreenSize().width - 100,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(allUserData[index].email, style: TextStyle(fontSize: 14)),
                                                          Text(
                                                            allUserData[index].job ?? "無",
                                                            style: TextStyle(color: Colors.grey, fontSize: 13),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        "${allUserData[index].lastLogin}天前",
                                                        style: TextStyle(color: Colors.grey, fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  allUserData[index].introduction != ""
                                                      ? Text("${allUserData[index].introduction}",
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(fontSize: 13, color: normalBgColor2))
                                                      : Container(),
                                                  Text(skillText, style: TextStyle(fontSize: 13)),
                                                  SkillListView(
                                                    fontSize: 11,
                                                    skillList: allUserData[index].mainSkills ?? [],
                                                  ),
                                                  Text(wantSkillText, style: TextStyle(fontSize: 13)),
                                                  SkillListView(
                                                    fontSize: 11,
                                                    skillList: allUserData[index].wantSkills ?? [],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  isAddDataLoading ? Loading() : Container(),
                                ],
                              );
                            }
                            return listComponent;
                          }),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
