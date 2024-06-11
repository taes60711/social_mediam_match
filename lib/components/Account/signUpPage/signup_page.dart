import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/CustomBouncingScrollPhysics.dart';
import 'package:social_mediam_match/components/account/signUpPage/signup_step_third.dart';
import 'package:social_mediam_match/components/account/signUpPage/signup_step_two.dart';
import 'package:social_mediam_match/components/utilities/custom_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/enum/skill_type.dart';
import 'package:social_mediam_match/provider/account/signUpPage/sign_up_view_model.dart';

import '../../../provider/account/signUpPage/sign_up_view_provider.dart';
import '../../../provider/home/user_setting_view_provider.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../utilities/background_widget.dart';
import '../../utilities/basic_top_bar.dart';
import 'signup_step_guide.dart';
import 'signup_step_one.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    print("signUP build");

    List<int> levelList = [1, 2, 3, 4, 5];

    return Stack(
      children: [
        BackgroundWidget(
          isSafeArea: true,
          child: StatefulWrapper(
            onInit: () async {
              SkillMapProvider skillProvider = context.read<SkillMapProvider>();
              await skillProvider.userSkillList();
            },
            child: _mainBuild(),
          ),
        ),
        Builder(builder: (context) {
          print("customEndDrawer");
          SignUpEndDrawerType endDrawer = context.select((SignUpViewProvider value) => value.endDrawerOpenInfo);
          SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();

          Widget endDrawerWidget = Container();
          if (endDrawer == SignUpEndDrawerType.haveSkill) {
            endDrawerWidget = EndDrawer(
              onDismissed: () => signUpViewProvider.changeEndDrawerStatus(SignUpEndDrawerType.close),
              child: Consumer<SkillMapProvider>(
                builder: (context, skillMapProvider, _) {
                  return Scaffold(
                    body: SingleChildScrollView(
                      physics: const NoLoadingCustomBouncingScrollPhysics(),
                      child: Column(
                        children: SkillType.values.map((e) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.value),
                              Column(
                                children: skillMapProvider.skillMap[e]!
                                    .map(
                                      (e) => PopupMenuButton(
                                        itemBuilder: (BuildContext context) {
                                          return levelList.map(
                                            (e) {
                                              return PopupMenuItem(
                                                value: e,
                                                child: Text("$e"),
                                              );
                                            },
                                          ).toList();
                                        },
                                        onSelected: (value) {
                                          skillMapProvider.skillLevelChange(e, value, "have");
                                        },
                                        child: SizedBox(
                                          width: ScreenSize.width,
                                          child: Row(
                                            children: [
                                              Expanded(child: Text(e.skillHave.name)),
                                              e.skillHave.level > 0
                                                  ? Row(
                                                      children: [
                                                        Text("${e.skillHave.level}"),
                                                        GestureDetector(
                                                          onTap: () {
                                                            skillMapProvider.skillLevelChange(e, 0, "have");
                                                          },
                                                          child: const Icon(FontAwesomeIcons.close, size: 15),
                                                        )
                                                      ],
                                                    )
                                                  : Text("${e.skillHave.level}")
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (endDrawer == SignUpEndDrawerType.wantSkill) {
            endDrawerWidget = EndDrawer(
              onDismissed: () => signUpViewProvider.changeEndDrawerStatus(SignUpEndDrawerType.close),
              child: Consumer<SkillMapProvider>(builder: (context, skillMapProvider, _) {
                return Scaffold(
                  body: SingleChildScrollView(
                    physics: const NoLoadingCustomBouncingScrollPhysics(),
                    child: Column(
                      children: SkillType.values.map((e) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.value),
                            Column(
                              children: skillMapProvider.skillMap[e]!
                                  .map(
                                    (e) => PopupMenuButton(
                                      itemBuilder: (BuildContext context) {
                                        return levelList.map(
                                          (e) {
                                            return PopupMenuItem(
                                              value: e,
                                              child: Text("$e"),
                                            );
                                          },
                                        ).toList();
                                      },
                                      onSelected: (value) {
                                        skillMapProvider.skillLevelChange(e, value, "want");
                                      },
                                      child: SizedBox(
                                        width: ScreenSize.width,
                                        child: Row(
                                          children: [
                                            Expanded(child: Text(e.skillWant.name)),
                                            e.skillWant.level > 0
                                                ? Row(
                                                    children: [
                                                      Text("${e.skillWant.level}"),
                                                      GestureDetector(
                                                        onTap: () {
                                                          skillMapProvider.skillLevelChange(e, 0, "want");
                                                        },
                                                        child: const Icon(FontAwesomeIcons.close, size: 15),
                                                      )
                                                    ],
                                                  )
                                                : Text("${e.skillWant.level}")
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              }),
            );
          }
          return endDrawerWidget;
        }),
      ],
    );
  }
}

Widget _mainBuild() {
  return Builder(
    builder: (context) {
      print("SignUpViewProvider pageIndex Change");
      int pageIndex = context.select((SignUpViewProvider value) => value.pageIndex);

      List<Widget> signUpAllStepPage = [
        const SignUpStepOne(),
        const SignUpStepTwo(),
        const SignUpStepThird(),
        const SignUpStepGuide(),
      ];

      List<String> signUpStepTitle = [
        StepOnePage.title,
        StepTwoPage.title,
        StepThirdPage.title,
        StepGuide.title,
      ];

      return Column(
        children: [
          BaseTopBar(
            backFunc: () => SignUpViewModel(context: context).backButtonFUnc(),
            title: signUpStepTitle[pageIndex],
          ),
          signUpAllStepPage[pageIndex],
        ],
      );
    },
  );
}
