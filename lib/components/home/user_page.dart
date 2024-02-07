import 'package:flutter/material.dart';
import '../../service/fb_service.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    FbService fireBaseService = FbService();
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            fireBaseService.signOut();
            Navigator.of(context)
                .popUntil((route) => route.settings.name == "/");
          },
          child: const Text("登出"),
        ),
      ],
    );
  }
}
