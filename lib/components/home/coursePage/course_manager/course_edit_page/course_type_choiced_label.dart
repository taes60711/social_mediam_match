import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/enum/skill_type.dart';

import '../../../../../provider/course/corse_edit_view_model.dart';

import '../../../../utilities/bottomSheets/base_bottom_sheet.dart';

import '../../../../utilities/main_button.dart';
import '../../../../utilities/style/screen_size.dart';
import '../../../../utilities/style/style_config.dart';
import '../../course_utilites.dart';

class CourseTypeChoicedLabel extends ConsumerStatefulWidget {
  const CourseTypeChoicedLabel({super.key});

  @override
  ConsumerState<CourseTypeChoicedLabel> createState() => _CourseTypeChoicedLabelState();
}

class _CourseTypeChoicedLabelState extends ConsumerState<CourseTypeChoicedLabel> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "類別",
          style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
        ),
        SizedBox(width: ScreenSize.fitPxWidth(10)),
        MainBtn(
            onPress: () {
              CourseLevelChoiceBottomSheet().show(context);
            },
            child: boardContaienr(
              Row(
                children: [
                  Text(
                    CourseUtilites().formattedTag(int.parse(ref.watch(courseChoiceType))),
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

class CourseLevelChoiceBottomSheet extends BaseBottomSheet {
  FixedExtentScrollController scrollController = FixedExtentScrollController();
  List<String> item = [];
  @override
  double buildHeight() {
    return 0.3;
  }

  @override
  Future<void> initState(WidgetRef ref) async {
    item = SkillType.values.map((e) => e.type.toString()).toList();

    int choicedItemsIndex = item.indexWhere((element) => element == ref.read(courseChoiceType.notifier).state);

    if (choicedItemsIndex != -1) {
      scrollController.jumpToItem(choicedItemsIndex);
    }

    render();
  }

  @override
  Widget build(WidgetRef ref) {
    return CupertinoPicker(
      scrollController: scrollController,
      itemExtent: 50,
      onSelectedItemChanged: (int index) {
        ref.read(courseChoiceType.notifier).update((state) => item[index]);
        render();
      },
      children: item
          .map(
            (e) => Center(
              child: Text(
                CourseUtilites().formattedTag(int.parse(e)),
                style: TextStyle(color: AppColors.whiteColor),
              ),
            ),
          )
          .toList(),
    );
  }
}
