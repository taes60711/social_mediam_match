import 'package:flutter/material.dart';

import '../../utilities/basic_top_bar.dart';

class Guide extends StatelessWidget {
  const Guide({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          BaseTopBar(
            title: "導覽",
          ),
        ],
      ),
    );
  }
}
