// ignore_for_file: use_build_context_synchronously, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import '../../services/user_service.dart';
import 'Initial_page.dart';

class TestPage extends ConsumerStatefulWidget {
  TestPage({super.key});

  @override
  ConsumerState<TestPage> createState() => _TestPageState();
}

class _TestPageState extends ConsumerState<TestPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController uidController = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BaseInputField(hintText: "userUID", controller: uidController),
            const SizedBox(height: 30),
            MainBtn(
              onPress: () async {
                await UserService().requestGetUserData(uidController.text);

                ref.read(loginedUserUID.notifier).update((state) => uidController.text);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Initialpage()));
              },
              title: "send",
            ),
          ],
        ),
      ),
    );
  }
}
