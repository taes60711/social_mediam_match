import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../models/user_model.dart';

class SkillListView extends StatelessWidget {
  final String? title;
  final List<SkillInfo> skillList;
  const SkillListView({super.key, this.title, required this.skillList});

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
    Color backGroundColor = normalBgColor;
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
                      (e) => Chip(
                        avatar: Icon(
                          levelIcon[e.level],
                          color: textColor,
                          size: 20,
                        ),
                        visualDensity: const VisualDensity(horizontal: 0.0, vertical: -4),
                        backgroundColor: backGroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              style: BorderStyle.none,
                            )),
                        label: Text(
                          e.name,
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    )
                    .toList(),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: backGroundColor,
                ),
                child: Text(
                  "暫無",
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
              ),
      ],
    );
  }
}
