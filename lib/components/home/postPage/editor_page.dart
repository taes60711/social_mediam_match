// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:quill_html_editor/quill_html_editor.dart';
// import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
// import 'package:social_mediam_match/components/utilities/rich_text_editor.dart';
// import 'package:social_mediam_match/components/utilities/label_input.dart';
// import 'package:social_mediam_match/models/post_model.dart';
// import 'package:social_mediam_match/provider/post/post_provider.dart';
// import 'package:social_mediam_match/provider/post/post_view_model.dart';
// import '../../../pageManager/setting/route_controller.dart';
// import '../../../provider/post/edit_page_model.dart';
// import '../../../provider/post/my_post_view_model.dart';
// import '../../strings/userPage/user_page_string.dart';
// import '../../utilities/apiListView/base_api_list_provider.dart';
// import '../../utilities/basic_top_bar.dart';

// QuillEditorController controller = QuillEditorController();
// TextEditingController titleInputController = TextEditingController();

// class EditorPage extends StatefulWidget {
//   const EditorPage({super.key});

//   @override
//   State<EditorPage> createState() => _EditorPageState();
// }

// class _EditorPageState extends State<EditorPage> {
//   @override
//   Widget build(BuildContext context) {
//     BuildContext postContext = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['postContext'];
//     int postBoradType = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['postBoradType'] ?? -1;
//     List<PostBoard> allPostBoradType =
//         (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['allPostBoradTypeList'];
//     String editorType = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['editorType'];

//     return StatefulWrapper(
//       onInit: () async {
//         if (postBoradType != -1) {
//           context
//               .read<PostProvider>()
//               .postEditBoardTypeOnChange(allPostBoradType.firstWhere((element) => element.type == postBoradType));
//         }
//       },
//       child: editorType == "update"
//           ? ChangeNotifierProvider.value(
//               value: postContext.read<BaseAPIListProvider<PostModel>>(),
//               child: Builder(builder: (context) {
//                 PostModel postData = postContext.read<BaseAPIListProvider<PostModel>>().choiceData ?? PostModel();
//                 titleInputController.text = postData.title;
//                 return Scaffold(
//                   body: SafeArea(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         BaseTopBar(
//                           backFunc: () async {
//                             PostModel postData = postContext.read<BaseAPIListProvider<PostModel>>().choiceData ?? PostModel();
//                             titleInputController.text = postData.title;
//                             String content = await controller.getText();
//                             String title = titleInputController.text;
//                             if (postData.mainMessage != content || postData.title != title) {
//                               EditPageModel().editorExitCheck();
//                             } else {
//                               RouteOptions.pop();
//                             }
//                           },
//                           title: "文章編輯",
//                           rightWidget: GestureDetector(
//                             onTap: () async {
//                               await controller.getText().then(
//                                 (content) {
//                                   if (titleInputController.text == "" || content == "") {
//                                     EditPageModel().createPostCheck(titleInputController.text, content);
//                                   } else {
//                                     MyPostViewModel(myPostContext: postContext)
//                                         .updatePost(title: titleInputController.text, updateMsg: content);
//                                     RouteOptions.pop();
//                                   }
//                                 },
//                               );
//                             },
//                             child: Container(
//                               alignment: Alignment.centerRight,
//                               margin: const EdgeInsets.only(right: 10),
//                               width: 80,
//                               height: 35,
//                               child: Text(ProfileString().updateButtonText),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: editorContent(
//                             postContext: postContext,
//                             allPostBoradType: allPostBoradType,
//                             editorType: editorType,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//             )
//           : Builder(builder: (context) {
//               PostModel postData = PostModel();
//               titleInputController.text = postData.title;
//               return Scaffold(
//                 body: SafeArea(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       BaseTopBar(
//                         backFunc: () async {
//                           PostModel postData = PostModel();
//                           titleInputController.text = postData.title;
//                           String content = await controller.getText();
//                           String title = titleInputController.text;
//                           if (postData.mainMessage != content || postData.title != title) {
//                             EditPageModel().editorExitCheck();
//                           } else {
//                             RouteOptions.pop();
//                           }
//                         },
//                         title: "文章編輯",
//                         rightWidget: GestureDetector(
//                           onTap: () async {
//                             await controller.getText().then(
//                               (content) {
//                                 if (titleInputController.text == "" || content == "") {
//                                   EditPageModel().createPostCheck(titleInputController.text, content);
//                                 } else {
//                                   PostViewModel(context: postContext).createPost(
//                                     title: titleInputController.text,
//                                     msg: content,
//                                     type: context.read<PostProvider>().choicedPostType.type,
//                                   );
//                                   RouteOptions.pop();
//                                 }
//                               },
//                             );
//                           },
//                           child: Container(
//                             alignment: Alignment.centerRight,
//                             margin: const EdgeInsets.only(right: 10),
//                             width: 80,
//                             height: 35,
//                             child: const Text("新增"),
//                           ),
//                         ),
//                       ),

//                       ///タイトル、掲示板、文章編集
//                       Expanded(
//                         child: editorContent(
//                           allPostBoradType: allPostBoradType,
//                           editorType: editorType,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//     );
//   }

//   ///タイトル、掲示板、文章編集
//   Widget editorContent({BuildContext? postContext, required List<PostBoard> allPostBoradType, required String editorType}) {
//     return Builder(builder: (context) {
//       PostModel postData = PostModel();
//       if (postContext != null) {
//         postData = postContext.read<BaseAPIListProvider<PostModel>>().choiceData!;
//       }

//       titleInputController.text = postData.title;
//       return Column(
//         children: [
//           LabelInput(title: '標題', textController: titleInputController),
//           const SizedBox(height: 10),
//           Builder(
//             builder: (context) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Row(
//                   children: [
//                     const Text("看板"),
//                     const SizedBox(width: 10),
//                     IgnorePointer(
//                       ignoring: editorType == "update",
//                       child: DropdownButton(
//                         value: allPostBoradType.contains(context.select((PostProvider value) => value.choicedPostType))
//                             ? context.select((PostProvider value) => value.choicedPostType)
//                             : null,
//                         icon: Icon(
//                           Icons.keyboard_arrow_down,
//                           color: editorType == "update" ? Colors.grey : Colors.black,
//                         ),
//                         items: allPostBoradType.map((PostBoard items) {
//                           return DropdownMenuItem(
//                             value: items,
//                             child: Text(
//                               items.name,
//                               style: TextStyle(
//                                 color: editorType == "update" ? Colors.grey : Colors.black,
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           context.read<PostProvider>().postEditBoardTypeOnChange(value as PostBoard);
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: RichTextEditor(
//               content: postData.mainMessage,
//               controller: controller,
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }



