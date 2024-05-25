import 'package:flutter/material.dart';

import '../../../states/post_state.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class PostPageByTextFilter extends StatelessWidget {
  final PostState postState;
  const PostPageByTextFilter({required this.postState, super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController s = TextEditingController();
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 4, top: 2, bottom: 2),
                  width: ScreenSize().width,
                  height: 36,
                  child: TextField(
                    cursorColor: normalBgColor2,
                    controller: s,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                      hintText: "Search By title",
                      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                      fillColor: Colors.grey.withOpacity(0.3),
                      focusColor: Colors.grey.withOpacity(0.3),
                      filled: true,
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      iconColor: Colors.grey,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(8),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print("Cancel");
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  alignment: Alignment.center,
                  width: 50,
                  height: 36,
                  child: Text("Cancel"),
                ),
              )
            ],
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.black26,
          ),
        ],
      ),
    );
  }
}
