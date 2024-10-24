import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';

import '../../../services/user_service.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/style/style_config.dart';

class SkillUserChangePage extends ConsumerStatefulWidget {
  const SkillUserChangePage({super.key});

  @override
  ConsumerState<SkillUserChangePage> createState() => _SkillUserChangePageState();
}

final userExChangelistControllerProvider = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

class _SkillUserChangePageState extends ConsumerState<SkillUserChangePage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    ref.read(userExChangelistControllerProvider.notifier).size = 6;
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: APIListWidget(
        apiFunc: (page, size) {
          return UserService().getAllUserData(page, size, userUid: "tzLaMcP3V9XOAMOcD0FAY5Nf4tE2", filterSkill: []);
        },
        listControllerProvider: userExChangelistControllerProvider,
        itemChild: (data, index) {
          return Container(
            width: ScreenSize.width,
            decoration: BoxDecoration(
                color: AppColors.black37,
                borderRadius: BorderRadius.circular(
                  ScreenSize.fitPxWidth(15),
                )),
            margin: EdgeInsets.only(
              left: ScreenSize.fitPxHeight(10),
              right: ScreenSize.fitPxHeight(10),
              bottom: ScreenSize.fitPxHeight(10),
            ),
            padding: EdgeInsets.symmetric(
              vertical: ScreenSize.fitPxHeight(8),
              horizontal: ScreenSize.fitPxHeight(15),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    UserIcon(
                      iconSize: ScreenSize.fitPxWidth(50),
                      image: data.image,
                    ),
                    SizedBox(width: ScreenSize.fitPxWidth(10)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name ?? "",
                          style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize12),
                        ),
                        Text(
                          data.job ?? "",
                          style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: AppColors.greyColor98,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            FontAwesomeIcons.angleDoubleLeft,
                            color: AppColors.whiteColor,
                            size: ScreenSize.fitPxWidth(8),
                          ),
                        ),
                        Row(
                          children: data.mainSkills!.isEmpty
                              ? [
                                  Container(
                                    margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(3)),
                                    padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(5)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.blue,
                                    ),
                                    child: Text(
                                      "暫無",
                                      style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize12),
                                    ),
                                  )
                                ]
                              : data.mainSkills!.map((e) {
                                  return Container(
                                    margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(3)),
                                    padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(5)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.blue,
                                    ),
                                    child: Text(
                                      e.name,
                                      style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize12),
                                    ),
                                  );
                                }).toList(),
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: AppColors.greyColor98,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            FontAwesomeIcons.angleDoubleRight,
                            color: AppColors.whiteColor,
                            size: ScreenSize.fitPxWidth(8),
                          ),
                        ),
                        Row(
                          children: data.wantSkills!.isEmpty
                              ? [
                                  Container(
                                    margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(3)),
                                    padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(5)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.blue,
                                    ),
                                    child: Text(
                                      "暫無",
                                      style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize12),
                                    ),
                                  )
                                ]
                              : data.wantSkills!.map((e) {
                                  return Container(
                                    margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(3)),
                                    padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(5)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.blue,
                                    ),
                                    child: Text(
                                      e.name,
                                      style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize12),
                                    ),
                                  );
                                }).toList(),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
