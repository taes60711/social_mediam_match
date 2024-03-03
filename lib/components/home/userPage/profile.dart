import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

import '../../../global.dart';
import '../../../models/user_model.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    LoginUser userData = ModalRoute.of(context)!.settings.arguments as LoginUser;
    TextEditingController nameInput = TextEditingController();
    bool _switchSelected = true;
    bool _switchSelected1 = true;
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: ScreenSize().width,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
            ),
            TextField(
              controller: nameInput,
              decoration: InputDecoration(labelText: "用户名", hintText: "用户名", prefixIcon: Icon(Icons.person)),
            ),
            ExpansionTile(
              title: Text('タイトル'),
              leading: Icon(Icons.build_sharp),
              children: [
                Row(
                  children: [
                    const Expanded(child: Text("子要素1")),
                    Switch(
                        value: _switchSelected,
                        onChanged: (value) {
                          _switchSelected = value;
                        })
                  ],
                ),
                Row(
                  children: [
                    const Expanded(child: Text("子要素2")),
                    Switch(
                        value: _switchSelected1,
                        onChanged: (value) {
                          _switchSelected1 = value;
                        })
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                print(nameInput.text);
              },
              child: const Text("更新"),
            ),
          ],
        ),
      )),
    );
  }
}
