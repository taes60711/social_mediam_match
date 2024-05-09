import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/title_input.dart';

import '../../models/rich_text_format.dart';

class RichTextEditor extends StatelessWidget {
  final String content;
  final QuillEditorController controller;
  const RichTextEditor({required this.controller, required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    final customToolBarList = [ToolBarStyle.color, ToolBarStyle.size, ToolBarStyle.image];
    double fontSize = 18;
    return Column(
      children: [
        ToolBar.scroll(
          toolBarColor: Colors.cyan.shade50,
          controller: controller,
          direction: Axis.horizontal,
          toolBarConfig: customToolBarList,
          customButtons: [
            InkWell(
              onTap: () async {
                TextEditingController linkController = TextEditingController();

                Future<void> setLinkView() {
                  return showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Link'),
                        content: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: ScreenSize().width,
                          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                            TitleInput(title: 'Youtube URL', textController: linkController),
                          ]),
                        ),
                        actions: [
                          ElevatedButton(
                              child: Text('cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          ElevatedButton(
                            onPressed: () async {
                              String getVideoID(String url) {
                                int start = 0;
                                if (url.contains('/shorts/')) {
                                  start = url.indexOf('/shorts/') + '/shorts/'.length;
                                } else if (url.contains('/youtu.be/')) {
                                  start = url.indexOf('/youtu.be/') + '/youtu.be/'.length;
                                } else {
                                  start = url.indexOf('?v=') + '?v='.length;
                                }
                                int end = 0;
                                if (url.contains('&list')) {
                                  end = url.indexOf('&list');
                                } else if (url.contains('?si')) {
                                  end = url.indexOf('?si');
                                } else {
                                  end = url.length;
                                }

                                String tmpId = url.substring(start, end);
                                return tmpId;
                              }

                              String youtubeId = 'https://www.youtube.com/embed/${getVideoID(linkController.text)}';
                              String urlString =
                                  '<iframe class="ql-video" frameborder="0" allowfullscreen="true" src="$youtubeId"></iframe><p><br></p>';

                              await controller.insertText(urlString);
                              Navigator.pop(context);
                            },
                            child: Text("send"),
                          ),
                        ],
                      );
                    },
                  );
                }

                await setLinkView();
              },
              child: const Icon(FontAwesomeIcons.film),
            ),
            InkWell(
              onTap: () async {
                TextEditingController linkController = TextEditingController();
                TextEditingController linkTextController = TextEditingController();

                Future<void> setLinkView() {
                  return showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Link'),
                        content: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: ScreenSize().width,
                          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                            TitleInput(title: 'URL', textController: linkController),
                            TitleInput(title: 'Link Text', textController: linkTextController)
                          ]),
                        ),
                        actions: [
                          ElevatedButton(
                              child: Text('cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          ElevatedButton(
                            onPressed: () async {
                              String urlString =
                                  '<p><a href=${linkController.text} rel="noopener noreferrer" target="_blank">${linkTextController.text}</a><br></p>';
                              await controller.insertText(urlString);
                              Navigator.pop(context);
                            },
                            child: Text("send"),
                          ),
                        ],
                      );
                    },
                  );
                }

                await setLinkView();
              },
              child: const Icon(Icons.link_sharp),
            ),
          ],
        ),
        QuillHtmlEditor(
          text: RichTextFormat(htmlString: content).widgetToEditorHtml(content),
          controller: controller,
          minHeight: 1,
          textStyle: TextStyle(fontSize: fontSize),
          loadingBuilder: (context) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 0.4,
              ),
            );
          },
        ),
      ],
    );
  }
}
