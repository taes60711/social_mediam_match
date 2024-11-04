import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/Initial/Initial_page.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import '../../../enum/skill_type.dart';
import '../../../models/skill_model.dart';

class SkillChangeFilterPage extends BaseEndDrawer {
  Map<SkillType, List<RequestSkillListData>> mapedSkillList = {
    SkillType.frontend: [],
    SkillType.iot: [],
    SkillType.backend: [],
    SkillType.other: [],
  };

  Map<SkillType, List<RequestSkillListData>> filteredSkillMap = {
    SkillType.frontend: [],
    SkillType.iot: [],
    SkillType.backend: [],
    SkillType.other: [],
  };

  @override
  Future<void> initState(WidgetRef ref) async {
    List<RequestSkillListData> allSkillList = ref.read(allSkillListData);
    getFilterList(allSkillList);
    render();
  }

  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        BaseTopBar(backFunc: () => closePage()),
        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              width: ScreenSize.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: mapedSkillList.keys.map((e) {
                  String typeName = e.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.fitPxHeight(15),
                        ),
                        child: Text(
                          typeName,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: ScreenSize.fontSize18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Column(
                        children: mapedSkillList[e]!
                            .map(
                              (e) => MainBtn(
                                onPress: () {
                                  print(e.name);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: ScreenSize.fitPxHeight(10),
                                    horizontal: ScreenSize.fitPxHeight(20),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: AppColors.greyColor98, width: 0.6),
                                    ),
                                  ),
                                  width: ScreenSize.width,
                                  child: Text(
                                    e.name,
                                    style: TextStyle(
                                      color: AppColors.greyColor130,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(
                        height: ScreenSize.fitPxHeight(10),
                      )
                    ],
                  );
                }).toList(),
              ),
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
    filteredSkillMap = mapedSkillList.map((key, value) {
      return MapEntry(key, value.map((skill) => RequestSkillListData.copy(skill)).toList());
    });
  }
}
