import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/users_filter.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/user_detail.dart';
import 'package:social_mediam_match/components/strings/userPage/user_page_string.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/models/user_model.dart';
import '../../../states/skill_exchange_state.dart';
import '../../utilities/skill_list_view.dart';
import '../../utilities/style/screen_size.dart';
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
                                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    inspect(allUserData[index]);
                                    skillExChangeState.openDrawer("userDetail", otherUser: allUserData[index]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(255, 218, 219, 219),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              UserIcon(
                                                iconSize: 60,
                                                image: allUserData[index].image,
                                              ),
                                              Text(allUserData[index].email),
                                            ],
                                          ),
                                          Text("最後登入時間: ${allUserData[index].lastLogin}"),
                                          SizedBox(
                                            width: ScreenSize().width,
                                            child: SkillListView(
                                              title: skillText,
                                              skillList: allUserData[index].mainSkills ?? [],
                                            ),
                                          ),
                                          SizedBox(
                                            width: ScreenSize().width,
                                            child: SkillListView(
                                              title: wantSkillText,
                                              skillList: allUserData[index].wantSkills ?? [],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              listComponent = Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        inspect(allUserData[index]);
                                        skillExChangeState.openDrawer("userDetail", otherUser: allUserData[index]);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: const Color.fromARGB(255, 218, 219, 219),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  UserIcon(
                                                    iconSize: 60,
                                                    image: allUserData[index].image,
                                                  ),
                                                  Text(allUserData[index].email),
                                                ],
                                              ),
                                              Text("最後登入時間: ${allUserData[index].lastLogin}"),
                                              SizedBox(
                                                width: ScreenSize().width,
                                                child: SkillListView(
                                                  title: skillText,
                                                  skillList: allUserData[index].mainSkills ?? [],
                                                ),
                                              ),
                                              SizedBox(
                                                width: ScreenSize().width,
                                                child: SkillListView(
                                                  title: wantSkillText,
                                                  skillList: allUserData[index].wantSkills ?? [],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
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
