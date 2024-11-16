// import 'package:flutter/material.dart';
// import 'package:social_mediam_match/components/utilities/custom_button.dart';
// import 'package:social_mediam_match/components/utilities/label_input.dart';
// import 'package:social_mediam_match/models/feed_back_model.dart';

// import '../../../global.dart';

// import '../../../services/feed_back_service.dart';
// import '../../utilities/background_widget.dart';
// import '../../utilities/basic_top_bar.dart';

// class CustomServicePage extends StatefulWidget {
//   const CustomServicePage({super.key});

//   @override
//   State<CustomServicePage> createState() => _CustomServicePageState();
// }

// class _CustomServicePageState extends State<CustomServicePage> {
//   TextEditingController emailInput = TextEditingController();
//   TextEditingController titleInput = TextEditingController();
//   TextEditingController conentInput = TextEditingController();
//   String contentStr = "";
//   String errMessage = "";
//   @override
//   Widget build(BuildContext context) {
//     return BackgroundWidget(
//       child: Column(
//         children: [
//           const BaseTopBar(
//             title: "問題回報",
//           ),
//           LabelInput(
//             title: "標題",
//             textController: titleInput,
//             isRequired: true,
//           ),
//           LabelInput(
//             title: "Email",
//             textController: emailInput,
//             isRequired: true,
//           ),
//           MultiLabelInput(
//             title: "回報內容",
//             textController: conentInput,
//             isRequired: true,
//             displayText: contentStr,
//             maxdisplayLine: 15,
//             multiOnChange: (String value) {
//               contentStr = value;
//               setState(() {});
//             },
//           ),
//           const SizedBox(height: 10),
//           Visibility(
//             visible: errMessage != "",
//             child: Container(
//               alignment: Alignment.centerLeft,
//               padding: const EdgeInsets.only(left: 18),
//               child: Text(
//                 errMessage,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             ),
//           ),
//           // const SizedBox(height: 10),
//           MainBtn(
//               title: "送出",
//               onPress: () async {
//                 if (!inputVaildCheck()) {
//                   return;
//                 }
//                 print("send title ${titleInput.text} email ${emailInput.text} content ${conentInput.text}");
//                 FeedBackModel feedBack = FeedBackModel(title: titleInput.text, email: emailInput.text, content: conentInput.text);
//                 bool isSucess = await UserFeedBackService().createFeedBack(feedBack);
//                 if (isSucess) {
//                   sendFeedBackSucess();
//                 }
//               })
//         ],
//       ),
//     );
//   }

//   bool inputVaildCheck() {
//     if (titleInput.text == "" || emailInput.text == "" || conentInput.text == "") {
//       errMessage = "請每個項目都必須輸入\n";
//       if (titleInput.text == "") {
//         errMessage += "△ 標題 沒有輸入\n";
//       }
//       if (emailInput.text == "") {
//         errMessage += "△ Email 沒有輸入\n";
//       }
//       if (conentInput.text == "") {
//         errMessage += "△ 回報內容 沒有輸入\n";
//       }
//       setState(() {});
//       return false;
//     }
//     return true;
//   }

//   void sendFeedBackSucess() {
//     showDialog<void>(
//       context: globalContext,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           contentPadding: EdgeInsets.zero,
//           content: Container(
//             padding: const EdgeInsets.all(10),
//             margin: const EdgeInsets.all(15),
//             width: 180,
//             height: 150,
//             child: Column(
//               children: [
//                 const SizedBox(height: 10),
//                 const Expanded(
//                   child: Text("感謝回應"),
//                 ),
//                 MainBtn(title: "確認", onPress: () {}),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/bottomSheets/base_bottom_sheet.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';
import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';
import 'package:social_mediam_match/components/utilities/inputField/mutl_input.dart';

import '../../../models/feed_back_model.dart';
import '../../../services/feed_back_service.dart';
import '../../utilities/basic_top_bar.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class CustomServicePage extends BaseBottomSheet {
  @override
  double buildHeight() {
    return 0.93;
  }

  @override
  bool buildneedbarrerierClose() {
    return false;
  }

  @override
  BottomSheetPageType bottomSheetPageType() {
    return BottomSheetPageType.edit;
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        BaseTopBar(
          leftWidget: downCloseBtn(onPress: () {
            closePage();
          }),
          title: "問題回報",
          rightWidget: MainBtn(
            onPress: () async {
              print("send title ${titleController.text} email ${mailController.text} content ${contentController.text}");
              FeedBackModel feedBack =
                  FeedBackModel(title: titleController.text, email: mailController.text, content: contentController.text);
              bool isSucess = await UserFeedBackService().createFeedBack(feedBack);
              if (isSucess) {
                ConfirmDilaog(
                  title: "提示",
                  content: "感謝回覆",
                  conirmFunc: () {
                    closePage();
                  },
                ).show(context);
              }
            },
            title: "送出",
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
          child: Column(
            children: [
              inputField(hintText: "標題", editingController: titleController, fontSzie: ScreenSize.fontSize24),
              SizedBox(height: ScreenSize.fitPxWidth(16)),
              inputField(hintText: "信箱", editingController: mailController),
              SizedBox(height: ScreenSize.fitPxWidth(16)),
              MultInput(controller: contentController, hintText: "回報內容", minLines: 15, maxLines: 15),
            ],
          ),
        )
      ],
    );
  }

  Widget inputField({required String hintText, required TextEditingController editingController, double? fontSzie}) {
    double fs = fontSzie ?? ScreenSize.fontSize18;
    return BaseInputField(
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.greyColor130, fontSize: fs),
      inputStyle: TextStyle(color: AppColors.whiteColor, fontSize: fs),
      controller: editingController,
    );
  }
}
