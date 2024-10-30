import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/home/coursePage/course_page.dart';
import '../components/home/postPage/post_main_page.dart';
import '../components/home/skillExChangePage/skill_user_change_page.dart';

import '../components/home/userPage/user_page.dart';
import '../components/utilities/background_widget.dart';
import '../components/utilities/style/theme_style.dart';

import '../global/home_global_view_model.dart';
import 'setting/bottom_navigation_bar.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    HomeGlobalViewModel().init(
      ref: ref,
      render: () => setState(() {}),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> mainPage = [
      const PostMainPage(),
      const SkillUserChangePage(),
      const CourseMainPage(),
      CommonScaffold(
        child: Center(
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  ThemeStyle().onChangeTeme(AppThemeType.white);
                  setState(() {});
                },
                child: const Text("Theme to white"),
              ),
              ElevatedButton(
                onPressed: () {
                  ThemeStyle().onChangeTeme(AppThemeType.black);
                  setState(() {});
                },
                child: const Text("Theme to black"),
              ),
            ],
          ),
        ),
      ),
      const UserPage(),
    ];

    return Stack(
      children: [
        mainPage[ref.watch(bottomNavigationBarProvider)],
        AnimatedPositioned(
          duration: const Duration(milliseconds: 150),
          bottom: ref.read(bottomNavationBarPosProvider.notifier).state,
          child: const BottomBar(),
        ),
      ],
    );
  }
}
