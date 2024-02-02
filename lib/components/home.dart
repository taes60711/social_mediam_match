import 'package:flutter/material.dart';
import 'package:social_mediam_match/service/fb_service.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    fbService fireBaseService = fbService();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                fireBaseService.signOut();
                Navigator.of(context).pop();
              },
              child: const Text("登出"),
            ),
          ],
        ),
      ),
    );
  }
}
