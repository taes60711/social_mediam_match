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
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../services/user_service.dart';
import 'skill_user_change_page.dart';

final filteredSkillList = StateProvider<List<RequestSkillListData>>((ref) {
  return [];
});

class SkillChangeFilterPage extends BaseEndDrawer {
  final Function viewRender;
  SkillChangeFilterPage({required this.viewRender});
  Map<SkillType, List<RequestSkillListData>> mapedSkillList = {
    SkillType.frontend: [],
    SkillType.iot: [],
    SkillType.backend: [],
    SkillType.other: [],
  };

  List<RequestSkillListData> tempFilteredSkillList = [];

  @override
  Future<void> initState(WidgetRef ref) async {
    tempFilteredSkillList = ref.read(filteredSkillList).map((e) => RequestSkillListData.copy(e)).toList();

    List<RequestSkillListData> allSkillList = ref.read(allSkillListData);
    getFilterList(allSkillList);
    render();
  }

  @override
  Future<void> dispose(WidgetRef ref) async {}

  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        BaseTopBar(
          backFunc: () => closePage(),
          rightWidget: MainBtn(
              title: "篩選",
              onPress: () async {
                List<String> filteredSkillIdList = tempFilteredSkillList.map((e) => e.id.toString()).toList();
                ProfileData userData = ref.watch(loginUserData);
                await ref.read(userExChangelistControllerProvider.notifier).replaceApi((page, size) {
                  return UserService().getAllUserData(page, size, userUid: userData.uid, filterSkill: filteredSkillIdList);
                });

                ref.read(filteredSkillList.notifier).update((state) => tempFilteredSkillList);

                closePage();
                viewRender();
              }),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              width: ScreenSize.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: mapedSkillList.keys.map((type) {
                  String typeName = type.value;

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
                        children: mapedSkillList[type]!.map((e) {
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
                                  color: isChoiced ? AppColors.black37 : null,
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
  }
}
