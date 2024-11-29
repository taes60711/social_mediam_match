import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/provider/course/course_provider.dart';

class CourseEditViewModel {
  late BuildContext context;
  late WidgetRef ref;
  late Function render;

  void init(BuildContext context, WidgetRef ref, Function render) {
    this.context = context;
    this.ref = ref;
    this.render = render;
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController beforeNeedController = TextEditingController();

  void initData() {}

  void closePage() {
    resetAllData();
  }

  void resetAllData() {
    ref.read(courseDetailContent.notifier).update((state) => "");
    ref.read(courseEditSkillList.notifier).update((state) => []);
    ref.read(courseEditChapterList.notifier).update((state) => []);
    ref.read(courseChoiceLevel.notifier).update((state) => "3");
  }
}
