import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/coursePage/course_utilites.dart';
import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/services/course_service.dart';
import '../../../global/home_global_view_model.dart';
import '../../../models/course_model.dart';
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/background_widget.dart';
import '../../utilities/loading.dart';
import '../../utilities/style/screen_size.dart';

final courserMainPageListPorver = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

final choicedCourseProvider = StateProvider<CourseModel>((ref) {
  return CourseModel(courseCreateduserInfo: ProfileData());
});

class CourseMainPage extends ConsumerStatefulWidget {
  const CourseMainPage({super.key});

  @override
  ConsumerState<CourseMainPage> createState() => _CourseMainPageState();
}

class _CourseMainPageState extends ConsumerState<CourseMainPage> {
  @override
  Widget build(BuildContext context) {
    ProfileData userData = ref.watch(loginUserData);
    return CommonScaffold(
      type: PageType.main,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: ref.watch(bottomNavationBarPosProvider) != ScreenSize.fitPxHeight(-60) ? 50 : 0,
              ),
              Expanded(
                child: APIListWidget(
                    apiFunc: (int page, int size) {
                      return CourseService().getAllCourses(userData.uid, page, size);
                    },
                    listControllerProvider: courserMainPageListPorver,
                    haveBottomBar: true,
                    loadingWidget: const CourseLoading(),
                    itemChild: (data, index) {
                      return CourseUtilites().courseItemContent(context, ref, data: data);
                    }),
              ),
            ],
          ),
          AnimatedPositioned(
            top: ref.watch(bottomNavationBarPosProvider) != ScreenSize.fitPxHeight(-60) ? 3 : -45,
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 300),
            child: _buildSearchBar(ref, () => setState(() {}), context),
          ),
        ],
      ),
    );
  }
}

Widget _buildSearchBar(WidgetRef ref, Function render, BuildContext context) {
  return Container(
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
        Expanded(
          child: BaseInputField(
            hintText: "搜尋",
            controller: TextEditingController(),
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
  );
}
