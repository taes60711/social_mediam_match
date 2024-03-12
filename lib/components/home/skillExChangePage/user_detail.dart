import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

import '../../../states/friend_state.dart';

class UserDetail extends StatelessWidget {
  final GlobalKey<ScaffoldState> globalKey;
  const UserDetail({
    super.key,
    required this.globalKey,
  });

  @override
  Widget build(BuildContext context) {
    FriendState friendFuture = context.read<FriendState>();
    return SizedBox(
      width: ScreenSize().width,
      child: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(0),
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () async {
                  print("Drawer Close");
                  globalKey.currentState!.closeEndDrawer();
                },
                icon: const Icon(Icons.arrow_back_ios_sharp),
              ),
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.deepOrangeAccent,
            )
          ],
        ),
      ),
    );
  }
}
