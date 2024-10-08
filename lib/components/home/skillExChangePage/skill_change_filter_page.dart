import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/models/skill_model.dart';
import 'package:social_mediam_match/provider/home/skill_change_view_model.dart';

import '../../../enum/skill_type.dart';
import '../../../provider/home/skill_change_view_provider.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class SkillChangeFilterPage extends StatelessWidget {
  const SkillChangeFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: normalBgColor2.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  Map<SkillType, List<RequestSkillListData>> skillMap =
                      context.select((SkillChangeProvider value) => value.skillMap);
                  List<RequestSkillListData> filteredSkill = context.watch<SkillChangeProvider>().filteredSkill;
                  return SingleChildScrollView(
                    child: Column(
                      children: SkillType.values.map(
                        (skillType) {
                          return Column(
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
                                  child: Text(skillType.value, style: const TextStyle(color: Colors.white)),
                                ),
                              ),

                              Column(
                                children: skillMap[skillType]!.map((e) {
                                  return GestureDetector(
                                    onTap: () {
                                      context.read<SkillChangeProvider>().onChangeSkillFilter(e);
                                    },
                                    child: Container(
                                      width: ScreenSize.width,
                                      margin: const EdgeInsets.symmetric(vertical: 4),
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: filteredSkill.any((element) => element.name == e.name)
                                            ? normalBgColor
                                            : normalBgColor2.withOpacity(0.1),
                                      ),
                                      child: Text(e.name),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            TextBtn(
                title: tr("skillFilterSearch"),
                btnColor: normalBgColor,
                onPress: () {
                  SkillChangeViewModel(context: context).filterSearchStart();
                }),
          ],
        ),
      ),
    );
  }
}
