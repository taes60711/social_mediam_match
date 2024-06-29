import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';

class PostCommentPage extends StatelessWidget {
  const PostCommentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BaseTopBar(
          title: "留言",
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(),
          ),
        ),
      ],
    );
  }
}
