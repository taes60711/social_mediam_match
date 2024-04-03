import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../states/post_state.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    PostState postState = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['postState'];
    LoginUser userData = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['userData'] as LoginUser;
    int type = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['type'];
    TextEditingController introductionInput = TextEditingController();

    Widget userComponent = SafeArea(
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
              decoration: const InputDecoration(
                hintText: "文章內容",
                filled: true,
              ),
              keyboardType: TextInputType.multiline,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await postState.createPost(userData.uid, introductionInput.text, type);
              Navigator.pop(context);
            },
            child: Text("投稿"),
          ),
        ],
      ),
    );
    return Scaffold(body: userComponent);
  }
}
