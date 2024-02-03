import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_mediam_match/service/fb_service.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    FbService fireBaseService = FbService();
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Stream<List<dynamic>> getData() {
      //ReadData Sample
      final stream = firestore.collection("users").snapshots();
      inspect(stream.map((e) => e.docs.map((e) => e.data()).toList()));
      return stream.map((e) => e.docs.map((e) => e.data()).toList());
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                fireBaseService.signOut();
                Navigator.of(context)
                    .popUntil((route) => route.settings.name == "/");
              },
              child: const Text("登出"),
            ),
            ElevatedButton(
              onPressed: () {
                getData();
              },
              child: const Text("取得データ"),
            ),
          ],
        ),
      ),
    );
  }
}
