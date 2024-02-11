import 'package:flutter/material.dart';
import '../../service/fb_service.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    FbService fireBaseService = FbService();
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                fireBaseService.signOut();
                Navigator.of(context)
                    .popUntil((route) => route.settings.name == "/");
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("登出"),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.exit_to_app),
                ],
              ),
            ),
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.black38,
          ),
        ],
      ),
    );
  }
}
