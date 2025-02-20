// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/dialog/cant_touch_loading_dialog.dart';
import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../global.dart';
import '../../../../models/post_model.dart';
import '../../../../models/rich_text_format.dart';
import '../../../../provider/post/post_provider.dart';
import '../../../../provider/post/post_view_model.dart';
import '../../../../services/image_service.dart';
import '../../../utilities/FadeScalePage/image_view_page.dart';
import '../../../utilities/FadeScalePage/video_view_page.dart';
import '../../../utilities/bottomSheets/base_bottom_sheet.dart';
import '../../../utilities/FadeScalePage/base_fade_scale_page.dart';
import '../../../utilities/dialog/confirm_dialog.dart';
import '../../../utilities/inputField/label_input.dart';
import '../../../utilities/main_button.dart';
import '../../../utilities/rich_text_editor.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/app_colors.dart';

class PostCreatePage extends BaseFadeScalePage {
  PostBoard? postBoard;
  PostCreatePage({this.postBoard});

  TextEditingController titleController = TextEditingController();
  TextEditingController mainMessageController = TextEditingController();
  List<String> fileMessage = [];

  @override
  bool needWaitOpenPage() {
    return true;
  }

  late PostViewModel viewModel;

  @override
  Future<void> initState(WidgetRef ref) async {
    viewModel = PostViewModel(ref: ref, context: context, render: render);
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

                ///　文章作る
                if (viewModel.postCreateBeforCheck(
                  postTitle: titleController.text,
                  postContent: mainMessageController.text,
                )) {
                  await viewModel.postCreate(
                    postTitle: titleController.text,
                    mainMessage: mainMessageController.text,
                    fileMessage: fileMessage,
                    postBoard: postBoard,
                  );
                  CanTouchScreenLoadingDialog().close();
                } else {
                  CanTouchScreenLoadingDialog().close();
                }
              },
              title: "投稿",
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseInputField(
                      hintText: "標題",
                      hintStyle: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize24),
                      inputStyle: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize24),
                      controller: titleController,
                    ),
                    SizedBox(height: ScreenSize.fitPxHeight(10)),
                    PostBoardChoicedLabel(postBoard: postBoard),
                    SizedBox(height: ScreenSize.fitPxHeight(15)),
                    BaseInputField(
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      hintText: "請輸入內文",
                      controller: mainMessageController,
                    ),
                    SizedBox(height: ScreenSize.fitPxHeight(10)),
                    fileMessageEditor(),
                    SizedBox(height: ScreenSize.fitPxHeight(10)),
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
                              String bas64img = await imageChoice();
                              if (bas64img != "") {
                                CanTouchScreenLoadingDialog().show();
                                String uid = const Uuid().v1();

                                String imageIsExistId = await ImageService().imageIsExist(bas64img);

                                if (imageIsExistId != "-1") {
                                  uid = imageIsExistId;
                                } else {
                                  await ImageService().saveImg(uid, bas64img);
                                }

                                String httpImg =
                                    "${APIHttpController.prefixUrl}://${APIHttpController.databaseDomainStr}/images/$uid";

                                fileMessage.add(httpImg);
                                CanTouchScreenLoadingDialog().close();
                                render();
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
                                  String imgUrl = imageLinkController.text;

                                  if (!RichTextFormat().imgUrlCheck(imgUrl)) {
                                    ConfirmDilaog(title: "警告", content: "請輸入有效的圖片網址", btnAmount: 1).show(context);
                                    return false;
                                  }
                                  print(imgUrl);
                                  fileMessage.add(imgUrl);
                                  render();
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
                                  String ytId = RichTextFormat().getYtvideoID(linkController.text);

                                  if (ytId == "err") {
                                    ConfirmDilaog(title: "警告", content: "請輸入有效的Youtube網址", btnAmount: 1).show(context);
                                    return false;
                                  }
                                  String ytURL = 'https://www.youtube.com/embed/$ytId';
                                  fileMessage.add(ytURL);
                                  render();
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
          ),
        ],
      ),
    );
  }

  Widget fileMessageEditor() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: fileMessage.map((e) {
          String messageType = "null";

          if (e == "") {
          } else if (e.contains("youtube")) {
            messageType = "ytVideo";
          } else {
            messageType = "img";
          }

          switch (messageType) {
            case "ytVideo":
              String ytId = RichTextFormat().getYtvideoID(e);
              return messageContainer(
                deleteFunc: () {
                  fileMessage.remove('https://www.youtube.com/embed/$ytId');
                  render();
                },
                child: YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: ytId,
                    flags: const YoutubePlayerFlags(
                      disableDragSeek: true,
                      autoPlay: false,
                      mute: false,
                    ),
                  ),
                  onReady: () => {},
                  bottomActions: [
                    PlaybackSpeedButton(
                      icon: Icon(
                        FontAwesomeIcons.gear,
                        size: ScreenSize.fontSize18,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    ProgressBar(isExpanded: true),
                    RemainingDuration(),
                    GestureDetector(
                      onTap: () {
                        final Uri _url = Uri.parse("https://www.youtube.com/watch?v=$ytId");
                        launchUrl(_url);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          FontAwesomeIcons.windowRestore,
                          size: ScreenSize.fontSize18,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    MainBtn(
                      onPress: () {
                        VideoViewPage(ytId: ytId).show(context);
                      },
                      child: Icon(
                        Icons.fullscreen,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              );
            case "img":
              String realImg = e;
              if (e.contains(APIHttpController.databaseDomainStr)) {
                realImg = RichTextFormat().mappingIPAndPort(e);
              }

              return messageContainer(
                deleteFunc: () {
                  fileMessage.remove(e);
                  render();
                },
                child: GestureDetector(
                  onTap: () {
                    ImageViewPage(imgUrl: realImg).show(context);
                  },
                  child: CachedNetworkImage(
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
                  ),
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

    return result;
  }

  Future<bool> postExitCheck() async {
    bool isEdit = false;
    String postTitle = titleController.text;

    if (postTitle != "" || mainMessageController.text != "" || fileMessage.isNotEmpty) {
      isEdit = true;
    }
    return isEdit;
  }
}

class PostBoardChoicedLabel extends ConsumerStatefulWidget {
  final PostBoard? postBoard;

  const PostBoardChoicedLabel({super.key, this.postBoard});

  @override
  ConsumerState<PostBoardChoicedLabel> createState() => _PostBoardChoicedLabelState();
}

class _PostBoardChoicedLabelState extends ConsumerState<PostBoardChoicedLabel> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "看板",
          style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
        ),
        SizedBox(width: ScreenSize.fitPxWidth(10)),
        widget.postBoard != null
            ? Text(
                widget.postBoard!.chineseName,
                style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize18),
              )
            : MainBtn(
                onPress: () {
                  PostBoardChoiceBottomSheet().show(context);
                },
                child: boardContaienr(
                  Row(
                    children: [
                      Text(
                        ref.watch(postCreateChoiceBoard).chineseName,
                        style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(5)),
                      Icon(
                        FontAwesomeIcons.caretDown,
                        size: ScreenSize.fontSize16,
                        color: AppColors.whiteColor,
                      )
                    ],
                  ),
                )),
      ],
    );
  }

  Widget boardContaienr(Widget child) {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSize.fitPxHeight(5),
          vertical: ScreenSize.fitPxHeight(1),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.greyColor98,
        ),
        child: child);
  }
}

class PostBoardChoiceBottomSheet extends BaseBottomSheet {
  FixedExtentScrollController scrollController = FixedExtentScrollController();
  List<PostBoard> item = [];
  @override
  double buildHeight() {
    return 0.3;
  }

  @override
  Future<void> initState(WidgetRef ref) async {
    item = ref.read(allPostBoardListData.notifier).state;

    int choicedItemsIndex = item.indexWhere((element) => element.id == ref.read(postCreateChoiceBoard.notifier).state.id);

    if (choicedItemsIndex != -1) {
      scrollController.jumpToItem(choicedItemsIndex);
    }

    render();
  }

  @override
  Widget build(WidgetRef ref) {
    return CupertinoPicker(
      scrollController: scrollController,
      itemExtent: ScreenSize.fitPxWidth(50),
      onSelectedItemChanged: (int index) {
        ref.read(postCreateChoiceBoard.notifier).update((state) => item[index]);
        render();
      },
      children: item
          .map(
            (e) => Center(
              child: Text(
                e.chineseName,
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: ScreenSize.fontSize14,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
