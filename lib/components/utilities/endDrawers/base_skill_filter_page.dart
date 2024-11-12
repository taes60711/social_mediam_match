import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../enum/skill_type.dart';
import '../../../models/skill_model.dart';
import '../../Initial/Initial_page.dart';
import '../../utilities/basic_top_bar.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/endDrawers/base_end_drawer.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class BaseSkillFilterPage extends BaseEndDrawer {
  final Function viewRender;
  final StateProvider<List<RequestSkillListData>> filteredSkillList;
  final Function searchFunc;
  BaseSkillFilterPage({required this.viewRender, required this.filteredSkillList, required this.searchFunc});
  Map<SkillType, List<RequestSkillListData>> mapedSkillList = {
    SkillType.frontend: [],
    SkillType.iot: [],
    SkillType.backend: [],
    SkillType.other: [],
  };

  List<RequestSkillListData> tempFilteredSkillList = [];
  SkillType isChoicedSkillType = SkillType.frontend;
  double bottomBtnHeight = ScreenSize.fitPxHeight(80);

  @override
  Future<void> initState(WidgetRef ref) async {
    tempFilteredSkillList = ref.read(filteredSkillList).map((e) => RequestSkillListData.copy(e)).toList();
    List<RequestSkillListData> allSkillList = ref.read(allSkillListData);
    getFilterList(allSkillList);
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
              rightWidget: filterSearch(),
            ),
            SizedBox(height: ScreenSize.fitPxWidth(8)),
            Container(
              width: ScreenSize.width,
              margin: EdgeInsets.only(left: ScreenSize.fitPxWidth(16)),
              child: skillTypeItems(),
            ),
            SizedBox(height: ScreenSize.fitPxWidth(16)),
            Expanded(
              child: SizedBox(
                width: ScreenSize.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: mapedSkillList[isChoicedSkillType]!.map((e) {
                      RequestSkillListData data = e;

                      bool isChoiced = tempFilteredSkillList.indexWhere((element) => element.id == data.id) != -1;

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (isChoiced) {
                                int index = tempFilteredSkillList.indexWhere((element) => element.id == data.id);
                                tempFilteredSkillList.removeAt(index);
                              } else {
                                tempFilteredSkillList.add(data);
                              }
                              render();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenSize.fitPxHeight(10),
                                horizontal: ScreenSize.fitPxHeight(20),
                              ),
                              color: isChoiced ? AppColors.black37 : Colors.transparent,
                              width: ScreenSize.width,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      data.name,
                                      style: TextStyle(
                                        color: isChoiced ? AppColors.whiteColor : AppColors.greyColor130,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  isChoiced
                                      ? Icon(
                                          Icons.check,
                                          color: AppColors.whiteColor,
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                          Container(height: 0.6, color: AppColors.greyColor98),
                        ],
                      );
                    }).toList(),
                  ),
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
            child: filterClearBtn(),
          ),
        )
      ],
    );
  }

  Widget filterSearch() {
    return MainBtn(
        title: "搜尋",
        onPress: () async {
          searchFunc();
        });
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

  Widget filterClearBtn() {
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
                tempFilteredSkillList.clear();
                render();
              },
              title: "清空",
            ),
          ),
        ),
      ],
    );
  }

  Future<void> getFilterList(List<RequestSkillListData> requestSkillListData) async {
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
