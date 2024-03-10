import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/models/user_model.dart';

import '../../../states/skill_exchange_state.dart';

class SkillExChangePage extends StatelessWidget {
  const SkillExChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    SkillExChangeState skillExChangeFuture = context.read<SkillExChangeState>();
    List<LoginUser> allUserData = context.select((SkillExChangeState value) => value.allUserData);

    return StatefulWrapper(
        onInit: () {
          skillExChangeFuture.getAllUserData();
        },
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_circle_right),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: allUserData.length,
                  itemBuilder: (context, index) {
                    List<String> skills = allUserData[index].mainSkills!.map((e) => e.name).toList();
                    List<String> wantSkills = allUserData[index].wantSkills!.map((e) => e.name).toList();
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Color.fromARGB(255, 218, 219, 219),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 8),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                Text(allUserData[index].email),
                              ],
                            ),
                            Text("最後登入時間: ${allUserData[index].lastLogin}"),
                            Text(skills.isNotEmpty ? "擅長的技能 : ${skills}" : "擅長的技能 : "),
                            Text(wantSkills.isNotEmpty ? "想學的技能 : ${wantSkills}" : "想學的技能 : "),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ));
  }
}
