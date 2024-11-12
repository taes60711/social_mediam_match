// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/provider/home/skill_choice_setting_view_model.dart';

import '../../CustomBouncingScrollPhysics.dart';
import '../../enum/skill_type.dart';
import '../../models/skill_model.dart';
import '../../provider/home/skill_map_provider.dart';
import '../strings/account/sign_up_strings.dart';
import '../utilities/endDrawers/base_end_drawer.dart';
import '../utilities/endDrawers/skill_setting_end_drawer.dart';
import '../utilities/style/screen_size.dart';
import '../utilities/style/style_config.dart';

class SkillChoiceSettingPage extends StatelessWidget {
  final SkillEndDrawerType skillType;
  final Function onDismissedFunc;
  const SkillChoiceSettingPage({super.key, required this.skillType, required this.onDismissedFunc});

  @override
  Widget build(BuildContext context) {
    List<int> levelList = [1, 2, 3, 4, 5];

    return EndDrawer(
      onDismissed: () => onDismissedFunc(),
      title: skillType.name,
      child: Consumer<SkillMapProvider>(
        builder: (context, skillMapProvider, _) {
          return BackgroundWidget(
            isSafeArea: false,
            child: Column(
              children: [
                searchBar(context),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: normalBgColor2.withOpacity(0.15),
                    ),
                    child: SingleChildScrollView(
                      physics: const NoBouncingScrollPhysics(),
                      child: Column(
                        children: SkillType.values.map((e) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// スキル種類
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: googleButtonColor.withOpacity(0.8),
                                  ),
                                  child: Text(e.value, style: const TextStyle(color: Colors.white)),
                                ),
                              ),

                              ///各スキルの詳細
                              Column(
                                children: skillMapProvider.filteredSkillMap[e]!.map((e) {
                                  RequestUserSkillData skillInfo = e.skillHave;
                                  if (skillType == SkillEndDrawerType.wantSkill) {
                                    skillInfo = e.skillWant;
                                  }

                                  return PopupMenuButton(
                                    itemBuilder: (BuildContext context) {
                                      return levelList.map(
                                        (e) {
                                          return PopupMenuItem(
                                            value: e,
                                            child: Text("$e"),
                                          );
                                        },
                                      ).toList();
                                    },
                                    onSelected: (value) {
                                      SKillChoiceSettingViewModel(context: context).skillChoice(skillType, skillInfo, value);
                                    },
                                    child: skillItem(context: context, skillType: skillType, skillInfo: skillInfo),
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget searchBar(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    width: ScreenSize.width,
    height: 36,
    child: TextField(
      cursorColor: normalBgColor2,
      controller: context.read<SkillMapProvider>().filterController,
      decoration: InputDecoration(
        hintText: tr("skillSearchHintText"),
        hintStyle: const TextStyle(fontSize: 14),
        prefixIcon: const Icon(Icons.search),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
        ),
        contentPadding: const EdgeInsets.all(8),
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        context.read<SkillMapProvider>().searchSkillByFilter(value);
      },
    ),
  );
}

Widget skillItem({
  required BuildContext context,
  required SkillEndDrawerType skillType,
  required RequestUserSkillData skillInfo,
}) {
  Widget wSkillLevel = Text(
    "${StepThirdPage.skillLevelHint}: ${skillInfo.level}",
    style: TextStyle(color: normalBgColor2, fontSize: 14),
  );
  if (skillInfo.level > 0) {
    wSkillLevel = Row(
      children: [
        Text(
          "${StepThirdPage.skillLevelHint}: ${skillInfo.level}",
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            SKillChoiceSettingViewModel(context: context).skillChoice(skillType, skillInfo, 0);
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(FontAwesomeIcons.close, size: 14, color: Colors.white),
          ),
        )
      ],
    );
  }
  return Container(
    width: ScreenSize.width,
    margin: const EdgeInsets.symmetric(vertical: 4),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: skillInfo.level > 0 ? normalBgColor : normalBgColor2.withOpacity(0.1),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            skillInfo.name,
            style: TextStyle(color: skillInfo.level > 0 ? Colors.white : normalBgColor2, fontSize: 14),
          ),
        ),
        wSkillLevel,
      ],
    ),
  );
}
