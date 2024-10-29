// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:social_mediam_match/components/utilities/apiListView/api_list_view.dart';

// import 'package:social_mediam_match/components/utilities/user_icon.dart';
// import 'package:social_mediam_match/models/user_model.dart';
// import 'package:social_mediam_match/provider/account/user_provider.dart';
// import 'package:social_mediam_match/provider/home/skill_change_view_provider.dart';
// import 'package:social_mediam_match/services/user_service.dart';
// import '../../../models/skill_model.dart';
// import '../../../provider/home/skill_change_view_model.dart';
// import '../../account/skill_bar.dart';
// import '../../utilities/endDrawers/skill_change_filter_end_drawer.dart';
// import '../../utilities/endDrawers/skill_setting_end_drawer.dart';
// import '../../utilities/endDrawers/user_detail_end_drawer.dart';
// import '../../strings/account/sign_up_strings.dart';
// import '../../strings/skillExChangePage/skill_change_page_string.dart';
// import '../../utilities/apiListView/base_api_list_provider.dart';

// import '../../utilities/loading.dart';
// import '../../utilities/stateful_wrapper.dart';

// import '../../utilities/style/screen_size.dart';
// import '../../utilities/style/style_config.dart';

// class SkillChangePage extends StatelessWidget {
//   const SkillChangePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StatefulWrapper(
//       onInit: () async {
//         await SkillChangeViewModel(context: context).init();
//       },
//       child: Stack(
//         children: [
//           _mainBody(context),
//           userDetailEndDrawer(),
//           skillChangeEndDrawer(),
//         ],
//       ),
//     );
//   }
// }

// Widget _mainBody(BuildContext context) {
//   return Column(
//     children: [
//       searchBar(context),
//       const SizedBox(height: 10),
//       Expanded(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Builder(
//             builder: (context) {
//               ProfileData userData = context.watch<UserProvider>().userData;
//               List<RequestSkillListData> filteredSkill = context.select((SkillChangeProvider value) => value.filteredSkill);

//               return APIListView<ProfileData>(
//                 apiFunc: (page, size) {
//                   List<String> filteredSkillNameList = filteredSkill.map((e) => e.name).toList();
//                   return UserService().getAllUserData(page, size, userUid: userData.uid, filterSkill: filteredSkillNameList);
//                 },
//                 providerList: context.watch<BaseAPIListProvider<ProfileData>>().listData,
//                 itemChild: (data, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       FocusScope.of(context).requestFocus(FocusNode());

//                       openUserDetailEndDrawer(context: context, otherUserData: data[index]);
//                     },
//                     child: Container(
//                       color: Colors.transparent,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SquareUserIcon(
//                             width: 65,
//                             height: 100,
//                             img: data[index].image,
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 //名前
//                                 Text(
//                                   data[index].name != "" ? data[index].name ?? "" : data[index].email,
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                                 //職業
//                                 Text(
//                                   data[index].job ?? SkillChangePageString.skExChpagenojobData,
//                                   style: TextStyle(
//                                     color: hintTextColor,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                                 //持っているスキル
//                                 Text(
//                                   StepThirdPage.haveSkillText,
//                                   style: const TextStyle(fontSize: 13),
//                                 ),
//                                 skillBar(
//                                   SkillEndDrawerType.haveSkill,
//                                   userData: data[index],
//                                   fontSize: 12,
//                                 ),
//                                 Text(
//                                   StepThirdPage.wantSkillText,
//                                   style: const TextStyle(fontSize: 13),
//                                 ),
//                                 skillBar(
//                                   SkillEndDrawerType.wantSkill,
//                                   userData: data[index],
//                                   fontSize: 12,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           //最後ログイン期日
//                           Text(
//                             "${data[index].lastLogin}${SkillChangePageString.skExChpagebeforDays}",
//                             style: TextStyle(color: hintTextColor, fontSize: 12),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//                 loadingBuilder: () {
//                   return const SkillChangeLoading();
//                 },
//               );
//             },
//           ),
//         ),
//       )
//     ],
//   );
// }

// Widget searchBar(BuildContext context) {
//   return Container(
//     margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//     width: ScreenSize.width,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(8),
//       border: Border.all(
//         color: Colors.grey,
//         width: 0.5,
//       ),
//     ),
//     height: 36,
//     child: Row(
//       children: [
//         Expanded(
//           child: TextField(
//             cursorColor: normalBgColor2,
//             controller: context.read<SkillChangeProvider>().nameFilterController,
//             decoration: InputDecoration(
//               hintText: tr("skillSearchHintText"),
//               hintStyle: const TextStyle(fontSize: 14),
//               prefixIcon: const Icon(Icons.search),
//               focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
//               contentPadding: const EdgeInsets.all(8),
//               border: const OutlineInputBorder(borderSide: BorderSide.none),
//             ),
//             onChanged: (value) {
//               SkillChangeViewModel(context: context).searchByNamePart(namePart: value);
//             },
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             FocusScope.of(context).requestFocus(FocusNode());
//             openSkillChangeEndDrawer(context: context);
//           },
//           child: Container(
//             width: 50,
//             height: 40,
//             color: Colors.transparent,
//             child: Icon(
//               FontAwesomeIcons.sliders,
//               size: 16,
//               color: normalBgColor2,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
