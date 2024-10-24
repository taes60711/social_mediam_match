import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

class BaseBottomSheet {
  void show(BuildContext context, {required Widget child}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(.1),
      builder: (BuildContext context) {
        return Container(
          height: ScreenSize.height * .8,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            color: Color.fromARGB(255, 42, 41, 41),
          ),
          child: Column(
            children: [
              Container(
                width: ScreenSize.width * 0.15,
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: child,
              ),
            ],
          ),
        );
      },
    );
  }
}
