import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/coursePage/course_detail.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/services/course_service.dart';
import '../../../global/global_view_model.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/background_widget.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/user_icon.dart';

// class CoursePage extends StatelessWidget {
//   const CoursePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StatefulWrapper(
//       onInit: () async {
//         courseContext = context;
//         await SkillChangeViewModel(context: context).init();
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.bgColor,
//         body: Stack(
//           children: [
//             _mainBuild(context),
//             // courseDetailEndDrawer(),
//             userDetailEndDrawer(),
//             courseFilterEndDrawer(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget _mainBuild(BuildContext context) {
//   return Column(
//     children: [
//       BaseTopBar(
//         leftWidget: Container(),
//         rightWidget: GestureDetector(
//           onTap: () {
//             openCourseFilterEndDrawer(context: context);
//           },
//           child: const Icon(FontAwesomeIcons.sliders),
//         ),
//       ),
//       Expanded(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 15),
//           child: APIListView<CourseModel>(
//             size: 6,
//             apiFunc: (int page, int size) {
//               ProfileData userData = context.read<UserProvider>().userData;
//               return CourseService().getAllCourses(userData.uid, page, size);
//             },
//             listType: ListType.grid,
//             providerList: context.watch<BaseAPIListProvider<CourseModel>>().listData,
//             customFloatbutton: GestureDetector(
//               onTap: () {
//                 RouteOptions.pushTo(RoutePath.courseEditPage, arguments: {
//                   "courseData": null,
//                   "context": context,
//                 });
//               },
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(25),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 1,
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   Icons.edit,
//                   size: 18,
//                   color: normalBgColor,
//                 ),
//               ),
//             ),
//             itemChild: (List<CourseModel> data, int index) {
//               return GestureDetector(
//                 onTap: () {
//                   // CourseViewModel(courseContext: context).courseDetailInit(openedCourse: data[index]);
//                 },
//                 child: Container(
//                   height: 260,
//                   margin: EdgeInsets.only(bottom: 5),
//                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       /// title
//                       Container(
//                         padding: const EdgeInsets.all(5),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: 50,
//                               child: Text(
//                                 data[index].title,
//                                 style: TextStyle(fontSize: 16),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "類別: 前端",
//                                   style: TextStyle(fontSize: 12, color: normalBgColor2),
//                                 ),
//                                 Text(
//                                   "難度: ${data[index].needLevel}",
//                                   style: TextStyle(fontSize: 12, color: normalBgColor2),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 16,
//                               child: SingleChildScrollView(
//                                 scrollDirection: Axis.horizontal,
//                                 child: Row(
//                                   children: data[index].courseLearningSkills.map((e) {
//                                     return Container(
//                                       decoration: BoxDecoration(color: normalBgColor2, borderRadius: BorderRadius.circular(5)),
//                                       margin: const EdgeInsets.only(right: 2),
//                                       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
//                                       child: Text(
//                                         e,
//                                         style: const TextStyle(color: Colors.white, fontSize: 10),
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "課程大綱: ",
//                               style: TextStyle(fontSize: 14, color: normalBgColor2),
//                             ),
//                             SizedBox(
//                               height: 45,
//                               child: Text(
//                                 data[index].content,
//                                 style: TextStyle(fontSize: 13, color: hintTextColor),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                             Text(
//                               "課程前需要: ",
//                               style: TextStyle(fontSize: 14, color: normalBgColor2),
//                             ),
//                             SizedBox(
//                               height: 25,
//                               child: Text(
//                                 data[index].beforeNeed,
//                                 style: TextStyle(color: hintTextColor, fontSize: 12),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.symmetric(vertical: 5),
//                         height: 0.3,
//                         width: ScreenSize.width,
//                         color: hintTextColor,
//                       ),
//                       const Expanded(child: SizedBox(height: 1)),
//                       GestureDetector(
//                         onTap: () {
//                           openUserDetailEndDrawer(context: context, otherUserData: data[index].courseCreateduserInfo);
//                         },
//                         child: Container(
//                           color: Colors.transparent,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   const Text(
//                                     "作成者:",
//                                     style: TextStyle(fontSize: 12),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 5),
//                                     child: UserIcon(
//                                       iconSize: 25,
//                                       image: data[index].courseCreateduserInfo.image,
//                                     ),
//                                   ),
//                                   SizedBox(width: 5),
//                                   Container(
//                                     width: 30,
//                                     alignment: Alignment.centerLeft,
//                                     color: Colors.transparent,
//                                     child: const Icon(
//                                       FontAwesomeIcons.arrowUpRightFromSquare,
//                                       color: Colors.black87,
//                                       size: 14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Text(
//                                     "最終更新日:${data[index].postTime}",
//                                     style: TextStyle(fontSize: 11, color: hintTextColor),
//                                   ),
//                                   const Expanded(child: SizedBox(width: 1)),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 8, bottom: 5),
//                                     child: Icon(
//                                       data[index].isPublic || data[index].signUpStatus == "added"
//                                           ? FontAwesomeIcons.unlock
//                                           : FontAwesomeIcons.lock,
//                                       size: 12,
//                                       color: data[index].isPublic ? normalBgColor : Colors.black,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//             loadingBuilder: () {
//               return const PostLoading();
//             },
//           ),
//         ),
//       ),
//     ],
//   );
// }

final courserMainPageListPorver = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

class CourseMainPage extends ConsumerStatefulWidget {
  const CourseMainPage({super.key});

  @override
  ConsumerState<CourseMainPage> createState() => _CourseMainPageState();
}

class _CourseMainPageState extends ConsumerState<CourseMainPage> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: ref.watch(bottomNavationBarPosProvider) != ScreenSize.fitPxHeight(-60) ? 50 : 0,
              ),
              Expanded(
                child: APIListWidget(
                    apiFunc: (int page, int size) {
                      return CourseService().getAllCourses("tzLaMcP3V9XOAMOcD0FAY5Nf4tE2", page, size);
                    },
                    listControllerProvider: courserMainPageListPorver,
                    itemChild: (data, index) {
                      return GestureDetector(
                        onTap: () {
                          CourseDetailPage().show(context);
                        },
                        child: Container(
                          width: ScreenSize.width,
                          color: AppColors.black37,
                          padding: EdgeInsets.symmetric(
                            vertical: ScreenSize.fitPxHeight(8),
                            horizontal: ScreenSize.fitPxHeight(15),
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  UserIcon(
                                    iconSize: 24,
                                    image: data.courseCreateduserInfo.image,
                                  ),
                                  SizedBox(width: ScreenSize.fitPxWidth(5)),
                                  Text(
                                    data.courseCreateduserInfo.name ?? "",
                                    style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                                  )
                                ],
                              ),
                              Text(
                                data.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: ScreenSize.fontSize16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: ScreenSize.fitPxWidth(5)),
                              Row(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.tag,
                                        color: AppColors.whiteColor.withOpacity(.6),
                                        size: ScreenSize.fontSize16,
                                      ),
                                      SizedBox(width: ScreenSize.fitPxWidth(2)),
                                      Text(
                                        "前端",
                                        style: TextStyle(
                                            color: AppColors.whiteColor.withOpacity(.6), fontSize: ScreenSize.fontSize12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: ScreenSize.fitPxWidth(5)),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: data.courseLearningSkills.map((e) {
                                          return Container(
                                            margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(3)),
                                            padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(8)),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: AppColors.greyColor98,
                                            ),
                                            child: Text(
                                              e,
                                              style: TextStyle(
                                                color: AppColors.whiteColor,
                                                fontSize: ScreenSize.fontSize12,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: ScreenSize.fitPxHeight(5)),
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.book,
                                    color: AppColors.whiteColor,
                                    size: ScreenSize.fontSize14,
                                  ),
                                  SizedBox(width: ScreenSize.fitPxWidth(5)),
                                  Text(
                                    "大綱",
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                data.content,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.greyColor130,
                                  fontSize: ScreenSize.fontSize12,
                                ),
                              ),
                              SizedBox(height: ScreenSize.fitPxHeight(5)),
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.wrench,
                                    color: AppColors.whiteColor,
                                    size: ScreenSize.fontSize14,
                                  ),
                                  SizedBox(width: ScreenSize.fitPxWidth(5)),
                                  Text(
                                    "前置需求",
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: ScreenSize.fitPxWidth(5)),
                                  Padding(
                                    padding: EdgeInsets.only(top: ScreenSize.fitPxWidth(3)),
                                    child: Text(
                                      "難度 ${data.needLevel}",
                                      style: TextStyle(
                                        color: AppColors.greyColor130,
                                        fontSize: ScreenSize.fontSize12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                data.beforeNeed,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.greyColor130,
                                  fontSize: ScreenSize.fontSize12,
                                ),
                              ),
                              SizedBox(height: ScreenSize.fitPxHeight(5)),
                              Text(
                                "最終更新日:${data.postTime}",
                                style: TextStyle(
                                  color: AppColors.whiteColor.withOpacity(.6),
                                  fontSize: ScreenSize.fontSize12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
          AnimatedPositioned(
            top: ref.watch(bottomNavationBarPosProvider) != ScreenSize.fitPxHeight(-60) ? 3 : -45,
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 100),
            child: _buildSearchBar(ref, () => setState(() {}), context),
          ),
        ],
      ),
    );
  }
}

Widget _buildSearchBar(WidgetRef ref, Function render, BuildContext context) {
  return GestureDetector(
    onTap: () async {},
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.greyColor57,
        borderRadius: BorderRadius.circular(5),
      ),
      width: ScreenSize.width,
      height: 36,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.search, color: AppColors.whiteColor),
          ),
          Text(
            "搜尋",
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 14,
            ),
          ),
          const Expanded(child: SizedBox(width: 1)),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 50,
              height: 40,
              color: Colors.transparent,
              child: Icon(
                FontAwesomeIcons.sliders,
                size: ScreenSize.fontSize14,
                color: AppColors.whiteColor.withOpacity(.8),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
