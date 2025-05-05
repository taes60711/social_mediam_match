import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:social_mediam_match/components/utilities/dialog/base_dialog.dart';
import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';

import 'package:social_mediam_match/components/utilities/inputField/label_input.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

import 'package:social_mediam_match/components/utilities/style/app_colors.dart';

import '../../models/rich_text_format.dart';

import 'main_button.dart';

// class RichTextEditor extends StatelessWidget {
//   final String content;
//   final QuillEditorController controller;

//   const RichTextEditor({required this.controller, required this.content, super.key});

//   @override
//   Widget build(BuildContext context) {
//     final customToolBarList = [ToolBarStyle.color];

//     double fontSize = 18;
//     return SizedBox(
//       width: ScreenSize.width,
//       height: ScreenSize.height,
//       child: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: FutureBuilder<String>(
//                 future: RichTextFormat(htmlString: content).widgetToEditorHtml(content),
//                 builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (snapshot.hasData) {
//                     return QuillHtmlEditor(
//                       backgroundColor: AppColors.black28,
//                       text: snapshot.data,
//                       controller: controller,
//                       minHeight: ScreenSize.height / 2 - 100,
//                       hintText: "請輸入文字",
//                       hintTextStyle: TextStyle(color: AppColors.greyColor, fontSize: ScreenSize.fontSize14),
//                       textStyle: TextStyle(fontSize: fontSize, color: AppColors.whiteColor),
//                       loadingBuilder: (context) {
//                         return Container(
//                           color: AppColors.black28,
//                           height: ScreenSize.height / 2 - 100,
//                           child: const Loading(),
//                         );
//                       },
//                       onTextChanged: (value) {
//                         RegExp nonEnglishDigitRegex = RegExp(r'[^\x00-\x7F0-9]');
//                         if (nonEnglishDigitRegex.hasMatch(value)) {
//                           RegExp regExp = RegExp(r'<p><br><\/p>');
//                           RegExp sregExp = RegExp(r'<br><\/p>');
//                           if (!regExp.hasMatch(value) && sregExp.hasMatch(value)) {
//                             String replacedText = value.replaceAll("<br></p>", "</p>");
//                             controller.clear();
//                             controller.insertText(replacedText);
//                             controller.focus();
//                           }
//                         }
//                       },
//                       onFocusChanged: (p0) {},
//                     );
//                   } else {
//                     return const Center(
//                       child: Text('No data available'),
//                     );
//                   }
//                 },
//               ),
//             ),
//           ),

//           /// ToolBar
//           ToolBar.scroll(
//             toolBarColor: AppColors.transparent,
//             controller: controller,
//             direction: Axis.horizontal,
//             toolBarConfig: customToolBarList,
//             iconColor: AppColors.greyColor130,
//             customButtons: [
//               ///相簿Image
//               GestureDetector(
//                 onTap: () async {
//                   String bas64img = await imageChoice();
//                   if (bas64img != "") {
//                     /// 圖片編輯的時候*.8寬度
//                     String urlString = '<img src="data:image/jpeg;base64,$bas64img" width="${ScreenSize.width * 0.8}">';
//                     await controller.insertText(urlString);
//                   }
//                 },
//                 child: SizedBox(
//                   width: 26,
//                   height: 24,
//                   child: Icon(
//                     FontAwesomeIcons.image,
//                     size: 19,
//                     color: AppColors.greyColor130,
//                   ),
//                 ),
//               ),

//               ///Image網址
//               GestureDetector(
//                 onTap: () async {
//                   TextEditingController imageLinkController = TextEditingController();

//                   RichtTextDialog(
//                     contentWidget: LabelInput(
//                       hintText: "請輸入圖片網址",
//                       controller: imageLinkController,
//                       label: '圖片網址',
//                     ),
//                     conirmFunc: () async {
//                       String imgUrl = imageLinkController.text;

//                       if (!RichTextFormat().imgUrlCheck(imgUrl)) {
//                         ConfirmDilaog(title: "警告", content: "請輸入有效的圖片網址", btnAmount: 1).show(context);
//                         return false;
//                       }

//                       /// 圖片編輯的時候*.8寬度
//                       String urlString = '<img src="$imgUrl" width="${ScreenSize.width * 0.8}">';
//                       await controller.insertText(urlString);
//                       return true;
//                     },
//                   ).show(context);
//                 },
//                 child: SizedBox(
//                   width: 26,
//                   height: 24,
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         top: 1.7,
//                         child: Icon(
//                           FontAwesomeIcons.image,
//                           size: 19,
//                           color: AppColors.greyColor130,
//                         ),
//                       ),
//                       Positioned(
//                         right: -1.5,
//                         bottom: -6,
//                         child: Icon(
//                           Icons.link,
//                           size: 20,
//                           color: AppColors.greyColor130,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),

//               ///Youtube網址
//               GestureDetector(
//                 onTap: () async {
//                   TextEditingController linkController = TextEditingController();
//                   RichtTextDialog(
//                     contentWidget: LabelInput(
//                       hintText: "請輸入Youtube網址",
//                       controller: linkController,
//                       label: 'Youtube網址',
//                     ),
//                     conirmFunc: () async {
//                       String ytId = RichTextFormat().getYtvideoID(linkController.text);

//                       if (ytId == "err") {
//                         ConfirmDilaog(title: "警告", content: "請輸入有效的Youtube網址", btnAmount: 1).show(context);
//                         return false;
//                       }
//                       String ytURL = 'https://www.youtube.com/embed/$ytId';
//                       String urlString =
//                           '<iframe class="ql-video" frameborder="0" allowfullscreen="true" src="$ytURL"></iframe><p><br></p>';

//                       await controller.insertText(urlString);

//                       return true;
//                     },
//                   ).show(context);
//                 },
//                 child: Icon(
//                   FontAwesomeIcons.film,
//                   color: AppColors.greyColor130,
//                 ),
//               ),

//               ///連結網址
//               GestureDetector(
//                 onTap: () async {
//                   TextEditingController linkController = TextEditingController();
//                   TextEditingController linkTextController = TextEditingController();
//                   RichtTextDialog(
//                     contentWidget: Column(
//                       children: [
//                         LabelInput(
//                           hintText: "請輸入連結網址",
//                           controller: linkController,
//                           label: '連結網址',
//                         ),
//                         SizedBox(
//                           height: ScreenSize.fitPxWidth(10),
//                         ),
//                         LabelInput(
//                           hintText: "請輸入文字",
//                           controller: linkTextController,
//                           label: '文字',
//                         ),
//                       ],
//                     ),
//                     conirmFunc: () async {
//                       String url = linkController.text;
//                       String urlText = linkTextController.text;
//                       if (url.replaceAll(" ", "") == "" || !url.contains("http")) {
//                         ConfirmDilaog(title: "警告", content: "請輸入有效的網址", btnAmount: 1).show(context);
//                         return false;
//                       }

//                       if (urlText.replaceAll(" ", "") == "") {
//                         urlText = url;
//                       }

//                       String urlString = '<p><a href=$url rel="noopener noreferrer" target="_blank">$urlText</a><br></p>';
//                       await controller.insertText(urlString);

//                       return true;
//                     },
//                   ).show(context);
//                 },
//                 child: Icon(
//                   Icons.link_sharp,
//                   color: AppColors.greyColor130,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Future<String> imageChoice() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     String result = "";
//     String imgPickerResult = "";

//     if (image != null) {
//       File imgPath = File(image.path);
//       String base64String = base64Encode(imgPath.readAsBytesSync());
//       imgPickerResult = base64String;
//       result = imgPickerResult;
//     }

//     return result;
//   }
// }

class RichtTextDialog extends BaseDialog {
  Widget contentWidget;
  Function conirmFunc;

  RichtTextDialog({
    required this.contentWidget,
    required this.conirmFunc,
  });
  @override
  Widget build(WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSize.fitPxWidth(25),
        vertical: ScreenSize.fitPxHeight(15),
      ),
      margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(30)),
      decoration: BoxDecoration(
        color: AppColors.greyColor54,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          contentWidget,
          SizedBox(
            height: ScreenSize.fitPxWidth(15),
          ),
          Row(
            children: [
              Expanded(
                child: MainBtn(
                  backgroundColor: AppColors.black37,
                  padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(10)),
                  onPress: () {
                    closePage();
                  },
                  title: "取消",
                ),
              ),
              SizedBox(width: ScreenSize.fitPxWidth(15)),
              Expanded(
                child: MainBtn(
                  padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(10)),
                  backgroundColor: AppColors.orangeColor,
                  onPress: () async {
                    bool isValid = await conirmFunc();

                    if (isValid) {
                      closePage();
                    }
                  },
                  title: "確認",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
