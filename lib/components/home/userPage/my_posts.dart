import 'package:flutter/material.dart';

import '../../../global.dart';

class MyPosts extends StatelessWidget {
  const MyPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
        ],
      ),
    ));
  }
}
