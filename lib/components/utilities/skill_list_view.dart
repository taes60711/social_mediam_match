import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../models/user_model.dart';

class SkillListView extends StatelessWidget {
  final String? title;
  final double? fontSize;
  final List<SkillInfo> skillList;
  const SkillListView({super.key, this.title, this.fontSize, required this.skillList});

  @override
  Widget build(BuildContext context) {
    var levelIcon = {
      1: Icons.filter_1,
      2: Icons.filter_2,
      3: Icons.filter_3,
      4: Icons.filter_4,
      5: Icons.filter_5,
    };
    Color textColor = normalTextColor;
    Color backGroundColor = Color.fromARGB(255, 236, 157, 120);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null ? Text(title ?? "") : Container(),
        skillList.isNotEmpty
            ? Wrap(
                runSpacing: 5,
                spacing: 5,
                children: skillList
                    .map(
                      (e) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: backGroundColor,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              levelIcon[e.level],
                              color: normalTextColor,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              e.name,
                              style: TextStyle(color: normalTextColor, fontSize: fontSize ?? 14),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: backGroundColor,
                ),
                child: Text(
                  "none",
                  style: TextStyle(color: textColor, fontSize: fontSize ?? 16),
                ),
              ),
      ],
    );
  }
}
