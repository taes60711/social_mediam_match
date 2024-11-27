import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../provider/course/course_provider.dart';
import '../../../../utilities/app_common_tools.dart';
import '../../../../utilities/bottomSheets/base_bottom_sheet.dart';

import '../../../../utilities/main_button.dart';
import '../../../../utilities/style/screen_size.dart';
import '../../../../utilities/style/style_config.dart';

class CourseLevelChoicedLabel extends ConsumerStatefulWidget {
  const CourseLevelChoicedLabel({super.key});

  @override
  ConsumerState<CourseLevelChoicedLabel> createState() => _CourseLevelChoicedLabelState();
}

class _CourseLevelChoicedLabelState extends ConsumerState<CourseLevelChoicedLabel> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "程度",
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
                  ref.watch(courseChoiceLevel),
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
          ),
        ),
        SizedBox(width: ScreenSize.fitPxWidth(10)),
        AppCommonTools().levelSetsumeiBtn(context)
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
    item = ["1", "2", "3", "4", "5"];

    int choicedItemsIndex = item.indexWhere((element) => element == ref.read(courseChoiceLevel.notifier).state);

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
        ref.read(courseChoiceLevel.notifier).update((state) => item[index]);
        render();
      },
      children: item
          .map(
            (e) => Center(
              child: Text(
                e,
                style: TextStyle(color: AppColors.whiteColor),
              ),
            ),
          )
          .toList(),
    );
  }
}
