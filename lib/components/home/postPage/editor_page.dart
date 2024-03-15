import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/account/require_login.dart';
import 'package:social_mediam_match/states/services/db_service.dart';

import '../../../models/user_model.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginUser? userData = ModalRoute.of(context)!.settings.arguments as LoginUser?;
    TextEditingController introductionInput = TextEditingController();

    Widget userComponent;

    if (userData != null) {
      userComponent = SafeArea(
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
                DBService().createPost("", introductionInput.text);
              },
              child: Text("投稿"),
            ),
          ],
        ),
      );
    } else {
      userComponent = requireLogin();
    }
    return Scaffold(body: userComponent);
  }
}
