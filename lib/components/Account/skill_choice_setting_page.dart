// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/provider/home/skill_choice_setting_view_model.dart';

import '../../CustomBouncingScrollPhysics.dart';
import '../../enum/skill_type.dart';
import '../../models/skill_model.dart';
import '../../provider/home/skill_map_provider.dart';
import '../utilities/custom_end_drawer.dart';
import '../utilities/style/screen_size.dart';

class SkillChoiceSettingPage extends StatelessWidget {
  final SkillChoicePageType skillType;
  final Function onDismissedFunc;
  const SkillChoiceSettingPage({super.key, required this.skillType, required this.onDismissedFunc});

  @override
  Widget build(BuildContext context) {
    List<int> levelList = [1, 2, 3, 4, 5];

    return EndDrawer(
      onDismissed: () => onDismissedFunc(),
      child: Consumer<SkillMapProvider>(
        builder: (context, skillMapProvider, _) {
          return Scaffold(
            body: Column(
              children: [
                BaseTopBar(
                  backFunc: () => onDismissedFunc(),
                  title: skillType.name,
                ),
                searchBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const NoLoadingCustomBouncingScrollPhysics(),
                    child: Column(
                      children: SkillType.values.map((e) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// スキル種類
                            Text(e.value),

                            ///各スキルの詳細
                            Column(
                              children: skillMapProvider.skillMap[e]!.map((e) {
                                RequestUserSkillData skillInfo = e.skillHave;
                                if (skillType == SkillChoicePageType.want) {
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
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget searchBar() {
  return Container(
    width: ScreenSize.width,
    height: 80,
    color: Colors.blueAccent,
  );
}

Widget skillItem({
  required BuildContext context,
  required SkillChoicePageType skillType,
  required RequestUserSkillData skillInfo,
}) {
  Widget wSkillLevel = Text("${skillInfo.level}");
  if (skillInfo.level > 0) {
    wSkillLevel = Row(
      children: [
        Text("${skillInfo.level}"),
        GestureDetector(
          onTap: () {
            SKillChoiceSettingViewModel(context: context).skillChoice(skillType, skillInfo, 0);
          },
          child: const Icon(FontAwesomeIcons.close, size: 15),
        )
      ],
    );
  }
  return SizedBox(
    width: ScreenSize.width,
    child: Row(
      children: [
        Expanded(child: Text(skillInfo.name)),
        wSkillLevel,
      ],
    ),
  );
}
