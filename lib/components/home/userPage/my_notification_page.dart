import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';

class MyNotificationPage extends StatelessWidget {
  const MyNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          BaseTopBar(
            title: "通知",
          ),
        ],
      ),
    );
  }
}
