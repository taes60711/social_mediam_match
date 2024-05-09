import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/users_filter.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/user_detail.dart';
import 'package:social_mediam_match/components/strings/skillExChangePage/skill_change_page_string.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/models/user_model.dart';
import '../../../states/skill_exchange_state.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../utilities/skill_list_view.dart';
import '../../utilities/user_icon.dart';

class SkillExchangeLoading extends StatelessWidget {
  const SkillExchangeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.dehaze_rounded),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                title: Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            width: 65,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 30,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: ScreenSize().width,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 70,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 150,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 70,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 150,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

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
        Future.delayed(Duration(milliseconds: 200)).then((value) async =>
            skillExChangeState.getAllUserData(userUid: userData.uid, filterSkill: filterSkill, searchType: "First"));
      },
      child: Scaffold(
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
        body: BackgroundWidget(
          isSafeArea: true,
          child: isFirstLoading
              ? const SkillExchangeLoading()
              : Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          skillExChangeState.openDrawer("filter");
                        },
                        icon: const Icon(Icons.dehaze_rounded),
                      ),
                    ),
                    isReLoading ? const Loading() : Container(),
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification) {
                            print(scrollNotification.depth);
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
                              double titleTextSize = 14;
                              double normalTextSize = 13;
                              double dayTextSize = 12;
                              double skillTextSize = 11;
                              Widget mainBody = GestureDetector(
                                onTap: () {
                                  inspect(allUserData[index]);
                                  skillExChangeState.openDrawer("userDetail", otherUser: allUserData[index]);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  width: ScreenSize().width,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 0.2, color: normalBgColor2),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SquareUserIcon(width: 65, height: 100, img: allUserData[index].image),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      //名前
                                                      Text(
                                                        allUserData[index].name != ""
                                                            ? allUserData[index].name ?? ""
                                                            : allUserData[index].email,
                                                        style: TextStyle(fontSize: titleTextSize),
                                                      ),
                                                      //職業
                                                      Text(
                                                        allUserData[index].job ?? SkillChangePageString().skExChpagenojobData,
                                                        style: TextStyle(
                                                          color: hintTextColor,
                                                          fontSize: normalTextSize,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                //ラストログイン日時
                                                Text(
                                                  "${allUserData[index].lastLogin}${SkillChangePageString().skExChpagebeforDays}",
                                                  style: TextStyle(color: hintTextColor, fontSize: dayTextSize),
                                                ),
                                              ],
                                            ),
                                            //自己紹介
                                            allUserData[index].introduction != "" && allUserData[index].introduction != null
                                                ? Text("${allUserData[index].introduction}",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(fontSize: normalTextSize, color: normalBgColor2))
                                                : Container(),
                                            //スキルタイトル
                                            Text(StepTwoPage().haveSkillText, style: TextStyle(fontSize: normalTextSize)),
                                            SkillListView(
                                              fontSize: skillTextSize,
                                              skillList: allUserData[index].mainSkills ?? [],
                                            ),
                                            //スキルタイトル
                                            Text(StepTwoPage().wantSkillText, style: TextStyle(fontSize: normalTextSize)),
                                            SkillListView(
                                              fontSize: skillTextSize,
                                              skillList: allUserData[index].wantSkills ?? [],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                              Widget listComponent;
                              if (index != allUserData.length - 1) {
                                listComponent = mainBody;
                              } else {
                                listComponent = Column(
                                  children: [
                                    mainBody,
                                    isAddDataLoading ? const Loading() : Container(),
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
      ),
    );
  }
}
