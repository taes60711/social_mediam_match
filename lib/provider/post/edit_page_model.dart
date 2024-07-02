import 'package:flutter/material.dart';
import 'package:social_mediam_match/global.dart';

import '../../components/utilities/custom_button.dart';
import '../../components/utilities/style/style_config.dart';
import '../../pageManager/setting/route_controller.dart';

class EditPageModel {
  Future<void> editorExitCheck() {
    return showDialog<void>(
      context: globalContext,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(15),
            width: 150,
            height: 160,
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Expanded(
                  child: Text('文章正在編輯確定要離開?'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: '取消',
                        titleColor: normalTextColor,
                        backgroundColor: hintTextColor,
                        onPress: () {
                          RouteOptions.pop();
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomButton(
                        title: '確認',
                        titleColor: normalTextColor,
                        backgroundColor: normalBgColor,
                        onPress: () async {
                          RouteOptions.pop();
                          RouteOptions.pop();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> createPostCheck(String title, String content) {
    return showDialog<void>(
      context: globalContext,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(15),
            width: 150,
            height: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Visibility(
                  visible: title == "",
                  child: const Text(
                    "*標題不得為空",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Visibility(
                  visible: content == "",
                  child: const Text(
                    "*文章內容不得為空",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const Expanded(child: SizedBox(height: 10)),
                CustomButton(
                  title: '確認',
                  titleColor: normalTextColor,
                  backgroundColor: normalBgColor,
                  onPress: () async {
                    RouteOptions.pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
