import 'package:flutter/material.dart';
import 'package:social_mediam_match/states/services/db_service.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController introductionInput = TextEditingController();
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          Text("投稿"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              minLines: 5,
              maxLines: 255,
              controller: introductionInput,
              decoration: InputDecoration(
                hintText: "文章內容",
                filled: true,
              ),
              keyboardType: TextInputType.multiline,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              DBService().createPost();
            },
            child: Text("投稿"),
          ),
        ],
      )),
    );
  }
}
