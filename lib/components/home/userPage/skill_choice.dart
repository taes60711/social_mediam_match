import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/models/user_model.dart';
import '../../../global.dart';
import '../../../models/skill_model.dart';
import '../../../states/user_setting_state.dart';

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
    String level = "程度 : ";
    var items = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
    ];

    Future<void> warningPopView() {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(15),
              width: 180,
              height: 150,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                children: [
                  const Text('最多只能選擇七個技能'),
                  Expanded(child: Container()),
                  CustomButton(
                      title: '確認',
                      titleColor: normalTextColor,
                      backgroundColor: normalBgColor,
                      onPress: () {
                        Navigator.of(context).pop();
                      })
                ],
              ),
            ),
          );
        },
      );
    }

    int choicedCount = type == "have" ? allSkillItems.length : allWantSkillItems.length;
    Widget expansionWidget(String category, List<SkillModel> list, String type) {
      Widget component = Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(96, 214, 214, 214),
          borderRadius: BorderRadius.circular(4),
        ),
        child: ExpansionTile(
          title: Text(category),
          collapsedTextColor: Colors.black45,
          textColor: Colors.black45,
          collapsedIconColor: Colors.black45,
          iconColor: Colors.black45,
          initiallyExpanded: true,
          shape: Border.all(color: Colors.transparent),
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
                bool changeChoicedSkillLevel = false;

                type == "have"
                    ? allSkillItems.map((e) => e.skillHave.name == skillInfoItem.name).toList().forEach((element) {
                        if (element) {
                          changeChoicedSkillLevel = true;
                        }
                      })
                    : allWantSkillItems.map((e) => e.skillWant.name == skillInfoItem.name).toList().forEach((element) {
                        if (element) {
                          changeChoicedSkillLevel = true;
                        }
                      });

                if (choicedCount < 7 || changeChoicedSkillLevel) {
                  userSettingState.checkOnChange(skillInfoItem, choicedLevel: value);
                } else {
                  print("不能在選擇了");
                  warningPopView();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                width: ScreenSize().width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: skillInfoItem.level > 0 ? normalBgColor : Color.fromARGB(104, 177, 176, 176),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        skillInfoItem.name,
                        style: TextStyle(color: skillInfoItem.level > 0 ? normalTextColor : normalBgColor2),
                      ),
                    ),
                    Text(
                      level,
                      style: TextStyle(color: skillInfoItem.level > 0 ? normalTextColor : normalBgColor2),
                    ),
                    Text(
                      selectedItem,
                      style: TextStyle(color: skillInfoItem.level > 0 ? normalTextColor : normalBgColor2),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
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
          Text(type == "have" ? "能教的技能" : "想學的技能"),
          Text("($choicedCount / 7)", style: TextStyle(fontSize: 12)),
          SizedBox(
            height: 20,
          ),
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
