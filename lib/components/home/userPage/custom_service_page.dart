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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/BottomSheets/base_bottom_sheet.dart';

class CustomServicePage extends BaseBottomSheet {
  @override
  double buildHeight() {
    return 0.9;
  }

  @override
  bool buildneedbarrerierClose() {
    return false;
  }

  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            closePage();
          },
          child: Text("X"),
        ),
      ],
    );
  }
}
