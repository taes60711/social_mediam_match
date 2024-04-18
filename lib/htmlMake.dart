import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class htmlMake extends StatefulWidget {
  const htmlMake({super.key});

  @override
  State<htmlMake> createState() => _htmlMakeState();
}

class _htmlMakeState extends State<htmlMake> {
  final QuillEditorController controller = QuillEditorController();
  final customToolBarList = [ToolBarStyle.color, ToolBarStyle.size, ToolBarStyle.video, ToolBarStyle.link, ToolBarStyle.image];

  final TextEditingController myController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ToolBar.scroll(
              toolBarColor: Colors.cyan.shade50,
              controller: controller,
              toolBarConfig: customToolBarList,
              direction: Axis.horizontal,
            ),
            SingleChildScrollView(
                child: Column(
              children: [
                QuillHtmlEditor(
                  text: '',
                  controller: controller,
                  minHeight: 1,
                  textStyle: TextStyle(fontSize: 22),
                  loadingBuilder: (context) {
                    return const Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 0.4,
                    ));
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    print(await controller.getText());
                    myController.text = await controller.getText();
                  },
                  child: Text("getText"),
                ),
                Container(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text("按下${"getText"}後,複製下面的字串"),
                ),
                Container(
                  height: 10,
                ),
                TextField(
                  controller: myController,
                  decoration: InputDecoration(hintText: '不要再這邊輸入文字'),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
