import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import '../../../global.dart';
import '../../../models/skill_model.dart';
import '../../../states/user_setting_state.dart';
import '../../strings/userPage/profie_string.dart';

class SkillChoice extends StatelessWidget {
  List<SkillModel> forntSkillItems, backEndSkillItems, iotSkillItems, otherSkillItems;
  UserSettingState userSettingState;
  String type;
  SkillChoice(
      {super.key,
      required this.userSettingState,
      required this.forntSkillItems,
      required this.backEndSkillItems,
      required this.iotSkillItems,
      required this.otherSkillItems,
      required this.type});

  @override
  Widget build(BuildContext context) {
    Widget ExpansionWidget(String category, List<SkillModel> list, String type) {
      Widget component = ExpansionTile(
        title: Text(category),
        leading: const Icon(Icons.align_horizontal_left),
        children: list.map((e) {
          ProfileSkill skillInfoItem = type == "have" ? e.skillHave : e.skillWant;
          String? selectedItem = "${skillInfoItem.skillInfo.level}";

          return PopupMenuButton(
            offset: const Offset(0.0, 22),
            itemBuilder: (context) {
              return items
                  .map(
                    (e) => PopupMenuItem(
                      value: e,
                      child: SizedBox(
                        width: ScreenSize().width,
                        child: skillInfoItem.skillInfo.level.toString() == e
                            ? Row(
                                children: [
                                  Text(e),
                                  Icon(Icons.check),
                                ],
                              )
                            : Text(e),
                      ),
                    ),
                  )
                  .toList();
            },
            onSelected: (value) {
              userSettingState.checkOnChange(skillInfoItem, "level", choicedLevel: value);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Container(
                  width: ScreenSize().width,
                  color: skillInfoItem.skillInfo.level > 0 ? const Color.fromARGB(255, 155, 211, 236) : Colors.transparent,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(skillInfoItem.skillInfo.name),
                      ),
                      Text(level),
                      Text(selectedItem)
                    ],
                  )),
            ),
          );
        }).toList(),
      );

      return component;
    }

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ExpansionWidget(SkillType.forntend.value, forntSkillItems, type),
                ExpansionWidget(SkillType.backend.value, backEndSkillItems, type),
                ExpansionWidget(SkillType.iot.value, iotSkillItems, type),
                ExpansionWidget(SkillType.other.value, otherSkillItems, type),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
