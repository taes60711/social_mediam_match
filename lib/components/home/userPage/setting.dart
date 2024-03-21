import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/global.dart';

import '../../../states/user_state.dart';
import '../../strings/userPage/user_page_string.dart';
import '../../utilities/style/screen_size.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    UserState userFuture = context.read<UserState>();

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
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // await userFuture.signOut();
                  Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                },
                child: Text(signOutButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
