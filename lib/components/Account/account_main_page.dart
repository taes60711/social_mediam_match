import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/Account/login_page.dart';
import 'package:social_mediam_match/components/Account/welcome_page.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';

import 'signUpPage/signup_page.dart';

final pageControllerProvider = StateProvider((ref) => PageController(initialPage: 1));

class AccountMainPage extends ConsumerStatefulWidget {
  const AccountMainPage({super.key});

  @override
  ConsumerState<AccountMainPage> createState() => _AccountMainPageState();
}

class _AccountMainPageState extends ConsumerState<AccountMainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pageWidget = [
      SignUpPage(),
      WelcomePage(),
      LoginPage(),
    ];

    return CommonScaffold(
      child: PageView(
        controller: ref.read(pageControllerProvider),
        physics: const ClampingScrollPhysics(),
        children: pageWidget,
      ),
    );
  }
}
