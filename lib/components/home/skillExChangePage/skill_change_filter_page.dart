import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/provider/home/skill_change_view_model.dart';

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
                  List<String> skillList = context.select((SkillChangeProvider value) => value.skillList);
                  List<String> filteredSkill = context.watch<SkillChangeProvider>().filteredSkill;
                  return SingleChildScrollView(
                    child: Column(
                      children: skillList.map((e) {
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
                              color:
                                  filteredSkill.any((element) => element == e) ? normalBgColor : normalBgColor2.withOpacity(0.1),
                            ),
                            child: Text(e),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                SkillChangeViewModel(context: context).filterSearchStart();
              },
              child: Text(tr("skillFilterSearch")),
            ),
          ],
        ),
      ),
    );
  }
}
