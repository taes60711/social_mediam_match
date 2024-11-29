import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/Initial/Initial_page.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/app_common_tools.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/level_setsumei_end_drawer.dart';

import '../../../enum/skill_type.dart';
import '../../../models/skill_model.dart';

import '../../utilities/endDrawers/base_end_drawer.dart';
import '../../utilities/style/screen_size.dart';
import '../bottomSheets/base_bottom_sheet.dart';

import '../main_button.dart';
import '../style/style_config.dart';

class UserSkillChoicePage extends BaseEndDrawer {
  List<RequestUserSkillData> initSkillData;
  Function(List<RequestUserSkillData>) updateSkillDate;

  UserSkillChoicePage({required this.initSkillData, required this.updateSkillDate});
  Map<SkillType, List<RequestUserSkillData>> mapedSkillList = {
    SkillType.frontend: [],
    SkillType.iot: [],
    SkillType.backend: [],
    SkillType.other: [],
  };

  List<RequestUserSkillData> tempFilteredSkillList = [];
  SkillType isChoicedSkillType = SkillType.frontend;
  double bottomBtnHeight = ScreenSize.fitPxHeight(80);

  @override
  bool needGestureDetectorClosePage() {
    return false;
  }

  @override
  Future<void> initState(WidgetRef ref) async {
    tempFilteredSkillList = List.from(initSkillData);

    getFilterList(ref.read(allSkillListData).map((e) => RequestUserSkillData(name: e.name, level: 0, month: 0)).toList());
    render();
  }

  @override
  Widget build(WidgetRef ref) {
    return Stack(
      children: [
        Column(
          children: [
            BaseTopBar(
              backFunc: () => closePage(),
              centerWidget: Align(
                alignment: Alignment.centerRight,
                child: AppCommonTools().levelSetsumeiBtn(context),
              ),
              rightWidget: MainBtn(
                onPress: () {
                  LevelsetsumeiEndDrawer().show(context);
                  tempFilteredSkillList.clear();
                  render();
                },
                title: "清空", //"保存",
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: ScreenSize.fitPxWidth(8)),
                    choicedFilterSkillList(),
                    SizedBox(height: ScreenSize.fitPxWidth(8)),
                    Container(
                      width: ScreenSize.width,
                      margin: EdgeInsets.only(left: ScreenSize.fitPxWidth(16)),
                      child: skillTypeItems(),
                    ),
                    SizedBox(height: ScreenSize.fitPxWidth(16)),
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
                                color: choicedData != null ? AppColors.black37 : Colors.transparent,
                                width: ScreenSize.width,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data.name,
                                        style: TextStyle(
                                          color: choicedData != null ? AppColors.whiteColor : AppColors.greyColor130,
                                          fontWeight: FontWeight.w400,
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
            child: filterSaveBtn(),
          ),
        )
      ],
    );
  }

  Widget choicedFilterSkillList() {
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
                              decoration: BoxDecoration(
                                color: AppColors.black37,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "${data.level}",
                                  style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize12),
                                ),
                              ),
                            ),
                            Text(
                              data.name,
                              style: TextStyle(color: AppColors.whiteColor),
                            ),
                            SizedBox(width: ScreenSize.fitPxHeight(5)),
                            Icon(
                              FontAwesomeIcons.close,
                              color: AppColors.whiteColor,
                              size: ScreenSize.fitPxHeight(13),
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

  Widget filterSaveBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: ScreenSize.fitPxHeight(15)),
            child: MainBtn(
              padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxHeight(10)),
              margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(40)),
              onPress: () {
                updateSkillDate(tempFilteredSkillList);
                closePage();
              },
              title: "保存",
            ),
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
      } else {
        ///other
        mapedSkillList[SkillType.other]!.add(skillInfo);
      }
    }
  }
}

///スキルレベル調整
class SkillLevelChoice extends BaseBottomSheet {
  String? intSelectedItem;
  final Function(String value)? onLevelChange;
  SkillLevelChoice({this.intSelectedItem, this.onLevelChange});
  @override
  BottomSheetPageType bottomSheetPageType() {
    return BottomSheetPageType.edit;
  }

  @override
  double buildHeight() {
    return 0.35;
  }

  List<String> item = ["1", "2", "3", "4", "5"];
  FixedExtentScrollController scrollController = FixedExtentScrollController();
  int choicedIndex = 0;

  @override
  Future<void> initState(WidgetRef ref) async {
    if (intSelectedItem != null) {
      int index = item.indexWhere((e) => e == intSelectedItem);
      if (index != -1) {
        scrollController.animateToItem(index, duration: const Duration(milliseconds: 300), curve: Curves.bounceIn);
      }
    }
  }

  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        SizedBox(height: ScreenSize.fitPxWidth(10)),
        BaseTopBar(
          leftWidget: Container(),
          title: "程度",
          rightWidget: MainBtn(
            onPress: () async {
              if (onLevelChange != null) {
                String choicedLevel = item[choicedIndex];
                onLevelChange!(choicedLevel);
              }
              closePage();
            },
            title: "確認",
          ),
        ),
        SizedBox(height: ScreenSize.fitPxWidth(10)),
        Expanded(
          child: CupertinoPicker(
            itemExtent: 50,
            scrollController: scrollController,
            onSelectedItemChanged: (int value) {
              choicedIndex = value;
            },
            children: item
                .map(
                  (e) => Center(
                    child: Text(
                      "程度 $e",
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
