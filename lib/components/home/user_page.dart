import 'package:flutter/material.dart';
import '../../service/fb_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

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
          GestureDetector(
            onTap: () async {
              final wsUrl = Uri.parse('ws://192.168.1.109:8765');
              final channel = WebSocketChannel.connect(wsUrl);

              await channel.ready;

              channel.sink.add('received!');
              channel.stream.listen((message) {
                print(message);
              });
              print("test");
            },
            child: Container(
              width: 100,
              height: 100,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
