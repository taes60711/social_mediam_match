import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/models/user_model.dart';
import '../../../global.dart';
import '../../../models/skill_model.dart';
import '../../../states/user_setting_state.dart';
import '../../strings/userPage/profie_string.dart';

class SkillChoice extends StatelessWidget {
  final List<SkillModel> forntSkillItems, backEndSkillItems, iotSkillItems, otherSkillItems, allSkillItems, allWantSkillItems;
  final UserSettingState userSettingState;
  final String type;
  const SkillChoice(
      {super.key,
      required this.userSettingState,
      required this.forntSkillItems,
      required this.backEndSkillItems,
      required this.iotSkillItems,
      required this.otherSkillItems,
      required this.allSkillItems,
      required this.allWantSkillItems,
      required this.type});

  @override
  Widget build(BuildContext context) {
    int choicedCount = type == "have" ? allSkillItems.length : allWantSkillItems.length;
    Widget expansionWidget(String category, List<SkillModel> list, String type) {
      Widget component = ExpansionTile(
        title: Text(category),
        leading: const Icon(Icons.align_horizontal_left),
        children: list.map((e) {
          SkillInfo skillInfoItem = type == "have" ? e.skillHave : e.skillWant;
          String? selectedItem = "${skillInfoItem.level}";

          return PopupMenuButton(
            offset: const Offset(0.0, 22),
            itemBuilder: (context) {
              return items
                  .map(
                    (e) => PopupMenuItem(
                      value: e,
                      child: SizedBox(
                        width: ScreenSize().width,
                        child: skillInfoItem.level.toString() == e
                            ? Row(
                                children: [
                                  Text(e),
                                  const Icon(Icons.check),
                                ],
                              )
                            : Text(e),
                      ),
                    ),
                  )
                  .toList();
            },
            onSelected: (value) {
              if (choicedCount < 7) {
                userSettingState.checkOnChange(skillInfoItem, choicedLevel: value);
              } else {
                print("不能在選擇了");
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Container(
                  width: ScreenSize().width,
                  color: skillInfoItem.level > 0 ? const Color.fromARGB(255, 155, 211, 236) : Colors.transparent,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(skillInfoItem.name),
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
          Text("($choicedCount / 7)"),
          Expanded(
            child: ListView(
              children: [
                expansionWidget(SkillType.forntend.value, forntSkillItems, type),
                expansionWidget(SkillType.backend.value, backEndSkillItems, type),
                expansionWidget(SkillType.iot.value, iotSkillItems, type),
                expansionWidget(SkillType.other.value, otherSkillItems, type),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
