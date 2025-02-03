import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/Initial/Initial_page.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/app_common_tools.dart';
import 'package:social_mediam_match/components/utilities/toast.dart';
import '../../../enum/skill_type.dart';
import '../../../models/skill_model.dart';
import '../utilities/endDrawers/base_end_drawer.dart';
import '../utilities/endDrawers/user_skill_choice_page.dart';
import '../utilities/main_button.dart';
import '../utilities/style/screen_size.dart';
import '../utilities/style/app_colors.dart';

/// スキル選択ページ
class CompleteProfileStepPage extends BaseEndDrawer {
  Function(List<RequestUserSkillData> skills, List<RequestUserSkillData> wantSkills) choicedSkillData;
  CompleteProfileStepPage({required this.choicedSkillData});

  ScrollController scrollController = ScrollController();

  Map<SkillType, List<RequestUserSkillData>> mapedSkillList = {
    SkillType.frontend: [],
    SkillType.backend: [],
    SkillType.iot: [],
    SkillType.cloud: [],
    SkillType.programLanguage: [],
    SkillType.other: [],
  };

  List<RequestUserSkillData> tempFilteredSkillList = [];
  SkillType isChoicedSkillType = SkillType.frontend;
  double bottomBtnHeight = ScreenSize.fitPxHeight(80);

  int step = 0;
  List<RequestUserSkillData> skills = [];
  List<RequestUserSkillData> wantSkills = [];

  PageController pageController = PageController();

  @override
  bool needGestureDetectorClosePage() {
    return false;
  }

  @override
  Future<void> initState(WidgetRef ref) async {
    getFilterList(ref.read(allSkillListData).map((e) => RequestUserSkillData(name: e.name, level: 0, month: 0)).toList());
    render();
  }

  @override
  Widget build(WidgetRef ref) {
    List<Widget> pageWidget = [
      //強いスキル設定
      choiceSKillBody(
        title: "請選擇 能教的技能",
      ),
      //弱いスキル設定
      choiceSKillBody(
        title: "請選擇 想學的技能",
      ),
    ];

    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: pageWidget,
    );
  }

  Widget choiceSKillBody({required String title}) {
    return Stack(
      children: [
        Column(
          children: [
            BaseTopBar(
              leftWidget: Container(),
              centerWidget: Padding(
                padding: EdgeInsets.only(left: ScreenSize.fitPxWidth(45)),
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: ScreenSize.fontSize14,
                  ),
                ),
              ),
              rightWidget: Row(
                children: [
                  AppCommonTools().levelSetsumeiBtn(context),
                  MainBtn(
                    onPress: () {
                      tempFilteredSkillList.clear();
                      render();
                    },
                    title: "清空",
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenSize.fitPxWidth(8)),
            choicedSkillList(),
            SizedBox(height: ScreenSize.fitPxWidth(8)),
            Container(
              width: ScreenSize.width,
              margin: EdgeInsets.only(left: ScreenSize.fitPxWidth(16)),
              child: skillTypeItems(),
            ),
            SizedBox(height: ScreenSize.fitPxWidth(16)),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    Column(
                      children: mapedSkillList[isChoicedSkillType]!.map((e) {
                        RequestUserSkillData data = e;
                        RequestUserSkillData? choicedData;
                        int index = tempFilteredSkillList.indexWhere((element) => element.name == data.name);

                        if (index != -1) {
                          choicedData = tempFilteredSkillList[index];
                        }

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                SkillLevelChoice(
                                    intSelectedItem: tempFilteredSkillList
                                        .firstWhere((element) => element.name == e.name,
                                            orElse: () => RequestUserSkillData.empty())
                                        .level
                                        .toString(),
                                    onLevelChange: (value) {
                                      RequestUserSkillData wantAddSkill = e;
                                      wantAddSkill.level = int.parse(value);
                                      int index = tempFilteredSkillList.indexWhere((element) => element.name == e.name);
                                      if (index == -1) {
                                        tempFilteredSkillList.add(wantAddSkill);
                                      } else {
                                        tempFilteredSkillList[index].level = wantAddSkill.level;
                                      }
                                      render();
                                    }).show(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: ScreenSize.fitPxHeight(10),
                                  horizontal: ScreenSize.fitPxHeight(20),
                                ),
                                color: choicedData != null ? AppColors.black37 : AppColors.transparent,
                                width: ScreenSize.width,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data.name,
                                        style: TextStyle(
                                          color: choicedData != null ? AppColors.whiteColor : AppColors.greyColor130,
                                          fontWeight: FontWeight.w400,
                                          fontSize: ScreenSize.fontSize14,
                                        ),
                                      ),
                                    ),
                                    choicedData == null
                                        ? Container()
                                        : Row(
                                            children: [
                                              Text(
                                                "程度 ${choicedData.level}",
                                                style: TextStyle(
                                                  color: AppColors.whiteColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: ScreenSize.fontSize14,
                                                ),
                                              ),
                                              MainBtn(
                                                onPress: () {
                                                  RequestUserSkillData wantRemoveSkill = choicedData!;

                                                  tempFilteredSkillList.remove(wantRemoveSkill);
                                                  render();
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: ScreenSize.fitPxWidth(2), left: ScreenSize.fitPxWidth(15)),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: AppColors.whiteColor,
                                                    size: ScreenSize.fitPxWidth(15),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            Container(height: 0.6, color: AppColors.greyColor98),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: bottomBtnHeight),
          ],
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: ScreenSize.width,
            height: bottomBtnHeight,
            color: AppColors.black37,
            child: saveBtn(),
          ),
        )
      ],
    );
  }

  ///　選択したスキルリスト
  Widget choicedSkillList() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSize.fitPxWidth(10),
      ),
      width: ScreenSize.width,
      child: Row(
        children: [
          Text(
            "已選取",
            style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
          ),
          SizedBox(width: ScreenSize.fitPxWidth(8)),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: tempFilteredSkillList.asMap().entries.map((e) {
                  int index = e.key;
                  RequestUserSkillData data = e.value;
                  return MainBtn(
                    onPress: () {
                      tempFilteredSkillList.removeAt(index);
                      render();
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.greyColor54,
                          borderRadius: BorderRadius.circular(
                            ScreenSize.fitPxHeight(5),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.fitPxWidth(4),
                          vertical: ScreenSize.fitPxWidth(2),
                        ),
                        margin: EdgeInsets.only(right: ScreenSize.fitPxHeight(7)),
                        child: Row(
                          children: [
                            Container(
                              width: ScreenSize.fitPxWidth(15),
                              height: ScreenSize.fitPxWidth(15),
                              margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(5)),
                              decoration: BoxDecoration(color: AppColors.black37, shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  "${data.level}",
                                  style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize12),
                                ),
                              ),
                            ),
                            Text(
                              data.name,
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: ScreenSize.fontSize12,
                              ),
                            ),
                            SizedBox(width: ScreenSize.fitPxHeight(5)),
                            Icon(
                              FontAwesomeIcons.close,
                              color: AppColors.whiteColor,
                              size: ScreenSize.fontSize14,
                            )
                          ],
                        )),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// BottomBtn
  Widget saveBtn() {
    Widget sendBtnComponent = Container();

    if (step == 0) {
      sendBtnComponent = MainBtn(
        padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxHeight(10)),
        margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(40)),
        onPress: () {
          if (tempFilteredSkillList.isEmpty) {
            Toast().showCenter(msg: "請至少選擇一項技能");
            return;
          }

          skills = List.from(tempFilteredSkillList);

          step = 1;

          pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeIn,
          );

          isChoicedSkillType = SkillType.frontend;
          scrollController.jumpTo(0);
          tempFilteredSkillList.clear();

          render();
        },
        title: "下一步",
      );
    } else if (step == 1) {
      sendBtnComponent = MainBtn(
        padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxHeight(10)),
        margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(40)),
        onPress: () {
          if (tempFilteredSkillList.isEmpty) {
            Toast().showCenter(msg: "請至少選擇一項技能");
            return;
          }
          wantSkills = List.from(tempFilteredSkillList);
          choicedSkillData(skills, wantSkills);
          closePage();
        },
        title: "保存",
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: ScreenSize.fitPxHeight(15)),
            child: sendBtnComponent,
          ),
        ),
      ],
    );
  }

  Widget skillTypeItems() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: mapedSkillList.keys
            .map(
              (e) => Padding(
                padding: EdgeInsets.only(right: ScreenSize.fitPxWidth(10)),
                child: MainBtn(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenSize.fitPxWidth(20),
                    vertical: ScreenSize.fitPxWidth(6),
                  ),
                  backgroundColor: isChoicedSkillType == e ? AppColors.orangeColor : null,
                  title: e.value,
                  onPress: () {
                    isChoicedSkillType = e;
                    scrollController.jumpTo(0);
                    render();
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> getFilterList(List<RequestUserSkillData> requestSkillListData) async {
    for (var skillInfo in requestSkillListData) {
      String skillName = skillInfo.name;
      if (frontType.contains(skillName)) {
        ///front
        mapedSkillList[SkillType.frontend]!.add(skillInfo);
      } else if (backendType.contains(skillName)) {
        ///back
        mapedSkillList[SkillType.backend]!.add(skillInfo);
      } else if (iotType.contains(skillName)) {
        ///iot
        mapedSkillList[SkillType.iot]!.add(skillInfo);
      } else if (cloudType.contains(skillName)) {
        ///cloud
        mapedSkillList[SkillType.cloud]!.add(skillInfo);
      } else if (programLanguageType.contains(skillName)) {
        ///programLanguage
        mapedSkillList[SkillType.programLanguage]!.add(skillInfo);
      } else {
        ///other
        mapedSkillList[SkillType.other]!.add(skillInfo);
      }
    }
  }
}
