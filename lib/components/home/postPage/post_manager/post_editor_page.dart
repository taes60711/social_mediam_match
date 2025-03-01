// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';
import 'package:social_mediam_match/services/post_service.dart';
import 'package:uuid/uuid.dart';
import '../../../../global.dart';
import '../../../../models/post_model.dart';
import '../../../../models/rich_text_format.dart';
import '../../../../provider/post/post_provider.dart';
import '../../../../provider/post/post_view_model.dart';
import '../../../../services/image_service.dart';
import '../../../utilities/FadeScalePage/base_fade_scale_page.dart';
import '../../../utilities/FadeScalePage/video_image_view_page.dart';
import '../../../utilities/apiListView/api_list_controller.dart';
import '../../../utilities/dialog/cant_touch_loading_dialog.dart';
import '../../../utilities/dialog/confirm_dialog.dart';
import '../../../utilities/inputField/label_input.dart';
import '../../../utilities/main_button.dart';
import '../../../utilities/rich_text_editor.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/app_colors.dart';
import '../../../utilities/toast.dart';

class PostEditorPage extends BaseFadeScalePage {
  StateNotifierProvider<APIListControllerNotifier<PostModel>, APIListController<PostModel>> postListController;

  int dataIndex;
  PostEditorPage(this.postListController, {required this.dataIndex});
  TextEditingController mainMessageController = TextEditingController();
  List<String> fileMessage = [];
  ScrollController scrollController = ScrollController();

  String typeName = "";
  @override
  bool needWaitOpenPage() {
    return true;
  }

  late PostViewModel viewModel;

  @override
  Future<void> initState(WidgetRef ref) async {
    typeName = ref
        .read(allPostBoardListData)
        .firstWhere(
          (e) => e.id == ref.read(choicedPostProvider.notifier).state.type,
          orElse: () => PostBoard(),
        )
        .chineseName;

    mainMessageController.text = ref.read(choicedPostProvider.notifier).state.mainMessage;
    fileMessage = List.from(ref.read(choicedPostProvider.notifier).state.fileMessage);
    viewModel = PostViewModel(ref: ref, context: context, render: render);
    render();
  }

  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
      type: PageType.main,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseTopBar(
            leftWidget: GestureDetector(
              onTap: () async {
                if (await postExitCheck()) {
                  ConfirmDilaog(
                      title: '提示',
                      content: '正在編輯中, 確定要離開嗎？',
                      conirmFunc: () {
                        closePage();
                      }).show(context);
                } else {
                  closePage();
                }
              },
              child: Container(
                width: ScreenSize.fitPxWidth(40),
                height: ScreenSize.fitPxWidth(40),
                color: AppColors.transparent,
                child: Center(
                  child: Icon(
                    Icons.close,
                    size: ScreenSize.fontSize18,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
            rightWidget: MainBtn(
              onPress: () async {
                CanTouchScreenLoadingDialog().show();

                if (viewModel.postCreateBeforCheck(postContent: mainMessageController.text)) {
                  PostModel post = ref.read(choicedPostProvider.notifier).state;

                  String fileMessageStr = "[]";
                  List<String> uploadedfileList = [];
                  if (fileMessage.isNotEmpty) {
                    await Future.forEach(fileMessage, (file) async {
                      if (file.contains("editingBase64,")) {
                        String uid = const Uuid().v1();

                        String imgStr = RichTextFormat().getImage(file);

                        String imageIsExistId = await ImageService().imageIsExist(imgStr);

                        if (imageIsExistId != "-1") {
                          uid = imageIsExistId;
                        } else {
                          await ImageService().saveImg(uid, imgStr);
                        }

                        String httpImg = "${APIHttpController.prefixUrl}://${APIHttpController.databaseDomainStr}/images/$uid";
                        uploadedfileList.add(httpImg);
                      } else {
                        uploadedfileList.add(file);
                      }
                    });
                    fileMessageStr = listToListStr(uploadedfileList);
                  }

                  bool isSucess = await PostService().updatePost(
                    postId: post.id,
                    mainMessage: mainMessageController.text,
                    fileMessage: fileMessageStr,
                  );

                  if (isSucess) {
                    post.mainMessage = mainMessageController.text;
                    post.fileMessage = uploadedfileList.where((e) => e.isNotEmpty).toList();
                    ref.read(postListController.notifier).editData(dataIndex, post);

                    render();

                    closePage();
                  }
                }
                CanTouchScreenLoadingDialog().close();
              },
              title: "更新",
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Tag
                  Text(
                    "類別 $typeName",
                    style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize18),
                  ),
                  SizedBox(height: ScreenSize.fitPxHeight(15)),

                  ///Main Message
                  BaseInputField(
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    hintText: "請輸入內文",
                    controller: mainMessageController,
                  ),
                  SizedBox(height: ScreenSize.fitPxHeight(10)),

                  ///file Message
                  fileMessageEditor(),
                  SizedBox(height: ScreenSize.fitPxHeight(10)),

                  ///file MessageEditor
                  Container(
                    padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(6)),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.greyColor138, width: .5),
                      ),
                    ),
                    child: Row(
                      children: [
                        ///相簿Image
                        GestureDetector(
                          onTap: () async {
                            if (fileMessageLengthCheck()) {
                              String bas64img = await imageChoice();
                              if (bas64img != "") {
                                fileMessage.add(bas64img);

                                render();
                                await scrollControllerMoveToLastPos(scrollController);
                              }
                            }
                          },
                          child: SizedBox(
                            width: 26,
                            height: 24,
                            child: Icon(
                              FontAwesomeIcons.image,
                              size: 19,
                              color: AppColors.greyColor130,
                            ),
                          ),
                        ),
                        SizedBox(width: ScreenSize.fitPxWidth(10)),

                        ///Image網址
                        GestureDetector(
                          onTap: () async {
                            TextEditingController imageLinkController = TextEditingController();

                            RichtTextDialog(
                              contentWidget: LabelInput(
                                hintText: "請輸入圖片網址",
                                controller: imageLinkController,
                                label: '圖片網址',
                              ),
                              conirmFunc: () async {
                                if (fileMessageLengthCheck()) {
                                  String imgUrl = imageLinkController.text;

                                  if (!RichTextFormat().imgUrlCheck(imgUrl)) {
                                    ConfirmDilaog(title: "警告", content: "請輸入有效的圖片網址", btnAmount: 1).show(context);
                                    return false;
                                  }
                                  print(imgUrl);
                                  fileMessage.add(imgUrl);

                                  render();
                                  await scrollControllerMoveToLastPos(scrollController);
                                }

                                return true;
                              },
                            ).show(context);
                          },
                          child: SizedBox(
                            width: 26,
                            height: 24,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 1.7,
                                  child: Icon(
                                    FontAwesomeIcons.image,
                                    size: 19,
                                    color: AppColors.greyColor130,
                                  ),
                                ),
                                Positioned(
                                  right: -1.5,
                                  bottom: -6,
                                  child: Icon(
                                    Icons.link,
                                    size: 20,
                                    color: AppColors.greyColor130,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: ScreenSize.fitPxWidth(10)),

                        ///Youtube網址
                        GestureDetector(
                          onTap: () async {
                            TextEditingController linkController = TextEditingController();
                            RichtTextDialog(
                              contentWidget: LabelInput(
                                hintText: "請輸入Youtube網址",
                                controller: linkController,
                                label: 'Youtube網址',
                              ),
                              conirmFunc: () async {
                                if (fileMessageLengthCheck()) {
                                  String ytId = RichTextFormat().getYtvideoID(linkController.text);

                                  if (ytId == "err") {
                                    ConfirmDilaog(title: "警告", content: "請輸入有效的Youtube網址", btnAmount: 1).show(context);
                                    return false;
                                  }
                                  String ytURL = 'https://www.youtube.com/embed/$ytId';
                                  fileMessage.add(ytURL);

                                  render();
                                  await scrollControllerMoveToLastPos(scrollController);
                                }

                                return true;
                              },
                            ).show(context);
                          },
                          child: Icon(
                            FontAwesomeIcons.film,
                            color: AppColors.greyColor130,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> scrollControllerMoveToLastPos(ScrollController scrollController) async {
    await Future.delayed(const Duration(milliseconds: 200));
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget fileMessageEditor() {
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: fileMessage.asMap().entries.map((e) {
          int index = e.key;
          String value = e.value;

          String messageType = "null";

          if (value == "") {
          } else if (value.contains("youtube")) {
            messageType = "ytVideo";
          } else {
            messageType = "img";
          }

          switch (messageType) {
            case "ytVideo":
              String ytId = RichTextFormat().getYtvideoID(value);
              String ytImag = "https://img.youtube.com/vi/${ytId}/maxresdefault.jpg";
              return messageContainer(
                deleteFunc: () {
                  fileMessage.removeAt(index);
                  render();
                },
                child: GestureDetector(
                  onTap: () {
                    VideoImageViewPage(fileStr: fileMessage, initIndex: index).show(context);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: ytImag,
                        width: ScreenSize.width,
                        height: ScreenSize.fitPxWidth(190),
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return Shimmer.fromColors(
                            baseColor: AppColors.greyColor98,
                            highlightColor: AppColors.greyColor98.withOpacity(.7),
                            child: Container(
                              width: ScreenSize.width,
                              height: ScreenSize.fitPxWidth(120),
                              decoration: BoxDecoration(color: AppColors.greyColor98),
                            ),
                          );
                        },
                      ),
                      Opacity(
                        opacity: .7,
                        child: Container(
                          width: ScreenSize.fitPxWidth(50),
                          height: ScreenSize.fitPxWidth(50),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.black28,
                          ),
                          child: Center(
                            child: Icon(
                              FontAwesomeIcons.play,
                              size: ScreenSize.fitPxWidth(20),
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            case "img":
              String realImg = value;
              if (value.contains(APIHttpController.databaseDomainStr)) {
                realImg = RichTextFormat().mappingIPAndPort(value);
              }

              return messageContainer(
                deleteFunc: () {
                  fileMessage.removeAt(index);
                  render();
                },
                child: GestureDetector(
                  onTap: () {
                    VideoImageViewPage(fileStr: fileMessage, initIndex: index).show(context);
                  },
                  child: Builder(builder: (context) {
                    if (realImg.contains("editingBase64,")) {
                      realImg = RichTextFormat().getImage(realImg);

                      ///　base64画像
                      return Image.memory(
                        const Base64Decoder().convert(realImg),
                        gaplessPlayback: true,
                        fit: BoxFit.cover,
                      );
                    } else {
                      if (value.contains(APIHttpController.databaseDomainStr)) {
                        realImg = RichTextFormat().mappingIPAndPort(value);
                      }

                      ///　http画像
                      return CachedNetworkImage(
                        imageUrl: realImg,
                        width: ScreenSize.width,
                        height: ScreenSize.fitPxWidth(190),
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return Shimmer.fromColors(
                            baseColor: AppColors.greyColor98,
                            highlightColor: AppColors.greyColor98.withOpacity(.7),
                            child: Container(
                              width: ScreenSize.width,
                              height: ScreenSize.fitPxWidth(120),
                              decoration: BoxDecoration(color: AppColors.greyColor98),
                            ),
                          );
                        },
                      );
                    }
                  }),
                ),
              );
            default:
              return Container();
          }
        }).toList(),
      ),
    );
  }

  Widget messageContainer({required Widget child, required Function deleteFunc}) {
    return Padding(
      padding: EdgeInsets.only(right: ScreenSize.fitPxWidth(10)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: AppColors.greyColor57),
              ),
              width: ScreenSize.fitPxWidth(250),
              height: ScreenSize.fitPxWidth(150),
              child: child,
            ),
          ),
          Positioned(
            right: ScreenSize.fitPxWidth(8),
            top: ScreenSize.fitPxWidth(5),
            child: MainBtn(
              onPress: () {
                deleteFunc();
              },
              child: Container(
                width: ScreenSize.fitPxWidth(35),
                height: ScreenSize.fitPxWidth(35),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.black37,
                    border: Border.all(
                      color: AppColors.greyColor54,
                    )),
                child: Icon(
                  FontAwesomeIcons.close,
                  color: AppColors.whiteColor,
                  size: ScreenSize.fitPxWidth(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> imageChoice() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    String result = "";
    String imgPickerResult = "";

    if (image != null) {
      File imgPath = File(image.path);
      String base64String = base64Encode(imgPath.readAsBytesSync());
      imgPickerResult = base64String;
      result = imgPickerResult;
    }

    return "editingBase64,$result";
  }

  bool fileMessageLengthCheck() {
    if (fileMessage.length >= 7) {
      Toast().showCenter(msg: "不得超過7個檔案");
      return false;
    }
    return true;
  }

  String listToListStr(List<String> list) {
    List<String> editedList = [];

    for (var item in list) {
      if (item.isNotEmpty) {
        editedList.add(item);
      }
    }

    StringBuffer result = StringBuffer();
    result.write('[');

    for (int i = 0; i < editedList.length; i++) {
      result.write('"${editedList[i]}"');
      if (i < editedList.length - 1) {
        result.write(',');
      }
    }

    result.write(']');
    return result.toString();
  }

  Future<bool> postExitCheck() async {
    bool isEdit = false;

    if (mainMessageController.text != ref.read(choicedPostProvider.notifier).state.mainMessage ||
        fileMessage != ref.read(choicedPostProvider.notifier).state.fileMessage) {
      isEdit = true;
    }
    return isEdit;
  }
}
