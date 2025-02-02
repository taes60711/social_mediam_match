// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_mediam_match/components/home/firendsPage/firends_page.dart';
import 'package:social_mediam_match/components/utilities/lodaing_dialog.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/friend_model.dart';
import '../../../../models/notification_model.dart';
import '../../../../models/user_model.dart';
import '../../../../provider/account/user_provider.dart';
import '../../../../provider/friend/chat_room_ws_model.dart';
import '../../../../services/firebase_notification_service.dart';
import '../../../../services/image_service.dart';
import '../../../utilities/FadeScalePage/chat_room_image_send_check.dart';
import '../../../utilities/inputField/base_input.dart';
import '../../../utilities/main_button.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/app_colors.dart';

///コメント欄
class CommentBuild extends ConsumerStatefulWidget {
  final ChatRoomWSModel chatRoomWSModel;
  final int dataIndex;
  final ScrollController scrollController;
  final FriendListModel roomData;
  const CommentBuild(
      {super.key,
      required this.chatRoomWSModel,
      required this.dataIndex,
      required this.scrollController,
      required this.roomData});

  @override
  ConsumerState<CommentBuild> createState() => _CommentBuildState();
}

class _CommentBuildState extends ConsumerState<CommentBuild> {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ProfileData userData = ref.watch(loginUserData);
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: ScreenSize.width,
        decoration: BoxDecoration(
          color: AppColors.black37,
          border: Border(
            top: BorderSide(
              color: AppColors.greyColor54,
            ),
          ),
        ),
        height: ScreenSize.fitPxHeight(70),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(15)),
          child: Row(
            children: [
              ///画像ボタン
              MainBtn(
                onPress: () async {
                  String imageString = await imageChoice();
                  if (imageString != "") {
                    sendMsg(widget.chatRoomWSModel, userId: userData.uid, message: imageString);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxHeight(8), horizontal: ScreenSize.fitPxHeight(8)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ScreenSize.fitPxHeight(8)),
                    color: AppColors.greyColor57,
                  ),
                  margin: EdgeInsets.only(right: ScreenSize.fitPxHeight(10)),
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.fileImage,
                      size: ScreenSize.fontSize16,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),

              ///コメント
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    left: ScreenSize.fitPxHeight(8),
                    top: ScreenSize.fitPxHeight(6),
                    bottom: ScreenSize.fitPxHeight(6),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.greyColor57,
                    borderRadius: BorderRadius.circular(ScreenSize.fitPxHeight(13)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: BaseInputField(
                          hintText: "輸入訊息",
                          controller: commentController,
                          textInputAction: TextInputAction.newline,
                          autoFocus: true,
                          maxLines: 50,
                          minLines: 1,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sendMsg(widget.chatRoomWSModel, userId: userData.uid, message: commentController.text);
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.only(
                            left: ScreenSize.fitPxWidth(10),
                            right: ScreenSize.fitPxWidth(8),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenSize.fitPxWidth(8),
                              vertical: ScreenSize.fitPxWidth(3),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.orangeColor,
                              borderRadius: BorderRadius.circular(
                                ScreenSize.fitPxWidth(10),
                              ),
                            ),
                            child: Icon(
                              Icons.eco_sharp,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> imageChoice() async {
    final ImagePicker picker = ImagePicker();
    LoadingDialog().show();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    LoadingDialog().close();
    String result = "";
    String imgPickerResult = "";

    Completer<String> completer = Completer();
    if (image != null) {
      File imgPath = File(image.path);

      ChatRoomImageSendCheck(
          imgFile: imgPath,
          onPress: () async {
            String base64String = base64Encode(imgPath.readAsBytesSync());
            imgPickerResult = base64String;

            if (imgPickerResult != "") {
              LoadingDialog().show();
              String uid = const Uuid().v1();
              if (await ImageService().imageIsExist(imgPickerResult) != "-1") {
                uid = await ImageService().imageIsExist(imgPickerResult);
              } else {
                await ImageService().saveImg(uid, imgPickerResult);
              }
              String sendImgString = "http://\$ip:\$port/images/$uid";
              result = sendImgString;
              print("sendImgString $sendImgString");
              LoadingDialog().close();
              completer.complete(result);
            } else {
              print("no Image");
              completer.complete("");
            }
          }).show(context);
    }

    return completer.future;
  }

  void sendMsg(ChatRoomWSModel chatRoomWSModel, {required String userId, required String message}) {
    if (message == "") {
      return;
    }

    chatRoomWSModel.sendMessage(loginUserUID: userId, message: message);

    if (message.contains('http://\$ip:\$port')) {
      message = "傳送了圖像";
    }

    List<FriendListModel> friendList = ref.read(frinedListProvider);
    friendList[widget.dataIndex].lastMessage = message;
    ref.read(frinedListProvider.notifier).update((state) => List.from(friendList));
    setState(() {});
    commentController.text = "";
    widget.scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.linear);

    sendChatRoomNotification(message: message);
  }

  void sendChatRoomNotification({required String message}) {
    NotificationModel notification = NotificationModel.empty();
    notification.type = 3;
    notification.roomId = widget.chatRoomWSModel.enterRoomID;

    if (widget.chatRoomWSModel.notificationToken != "") {
      FirebaseNotificationService().sendNotification(
        title: ref.read(loginUserData.notifier).state.name ?? "",
        message: message,
        sendto: widget.chatRoomWSModel.notificationToken,
        notifiactionInfo: notification,
      );
    }
  }
}
