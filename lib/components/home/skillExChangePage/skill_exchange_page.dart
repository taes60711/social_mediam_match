import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_mediam_match/components/utilities/apiListView/api_list_view.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';
import 'package:social_mediam_match/provider/home/skill_change_provider.dart';
import 'package:social_mediam_match/services/user_service.dart';

import '../../../enum/skill_end_drawer_type.dart';
import '../../account/skill_bar.dart';
import '../../utilities/endDrawers/skill_change_filter_end_drawer.dart';
import '../../utilities/endDrawers/user_detail_end_drawer.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../strings/skillExChangePage/skill_change_page_string.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class SkillExchangeLoading extends StatelessWidget {
  const SkillExchangeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                title: Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            width: 65,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 30,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: ScreenSize.width,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 70,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 150,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 70,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 150,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SkillExChangePage extends StatelessWidget {
  const SkillExChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _mainBody(context),
        userDetailEndDrawer(),
        skillChangeEndDrawer(),
      ],
    );
  }
}

Widget _mainBody(BuildContext context) {
  return Column(
    children: [
      BaseTopBar(
        leftWidget: Container(),
        rightWidget: GestureDetector(
          onTap: () {
            openSkillChangeEndDrawer(context: context);
          },
          child: const Icon(Icons.dehaze_rounded),
        ),
      ),
      Expanded(
        child: Builder(
          builder: (context) {
            LoginUser userData = context.watch<UserProvider>().userData;
            List<String> filterSkill = context.select((SkillChangeProvider value) => value.filterSkill);

            return APIListView<LoginUser>(
              apiFunc: (page, size) {
                print("page $page size $size filterSkill: $filterSkill");
                return UserService().getAllUserData(page, 8, userUid: userData.uid, filterSkill: filterSkill);
              },
              providerList: context.watch<BaseAPIListProvider<LoginUser>>().listData,
              itemChild: (data, index) {
                return GestureDetector(
                  onTap: () {
                    openUserDetailEndDrawer(context: context, otherUserData: data[index]);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SquareUserIcon(
                          width: 65,
                          height: 100,
                          img: data[index].image,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //名前
                              Text(
                                data[index].name != "" ? data[index].name ?? "" : data[index].email,
                                style: const TextStyle(fontSize: 14),
                              ),
                              //職業
                              Text(
                                data[index].job ?? SkillChangePageString.skExChpagenojobData,
                                style: TextStyle(
                                  color: hintTextColor,
                                  fontSize: 13,
                                ),
                              ),
                              //持っているスキル
                              Text(
                                StepThirdPage.haveSkillText,
                                style: const TextStyle(fontSize: 13),
                              ),
                              skillBar(
                                SkillEndDrawerType.haveSkill,
                                userData: data[index],
                                fontSize: 12,
                              ),
                              Text(
                                StepThirdPage.wantSkillText,
                                style: const TextStyle(fontSize: 13),
                              ),
                              skillBar(
                                SkillEndDrawerType.wantSkill,
                                userData: data[index],
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ),
                        //最後ログイン期日
                        Text(
                          "${data[index].lastLogin}${SkillChangePageString.skExChpagebeforDays}",
                          style: TextStyle(color: hintTextColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loadingBuilder: () {
                return const SkillExchangeLoading();
              },
            );
          },
        ),
      )
    ],
  );
}
