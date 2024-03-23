import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class SkillListView extends StatelessWidget {
  final String title;
  final List<SkillInfo> skillList;
  const SkillListView({super.key, required this.title, required this.skillList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        skillList.isNotEmpty
            ? Wrap(
                runSpacing: 5,
                spacing: 5,
                children: skillList
                    .map(
                      (e) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 233, 231, 231),
                        ),
                        child: Text(e.name),
                      ),
                    )
                    .toList(),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 233, 231, 231),
                ),
                child: Text("暫無"),
              ),
      ],
    );
  }
}
