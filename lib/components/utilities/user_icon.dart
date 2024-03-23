import 'dart:convert';

import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {
  final double iconSize;
  final String? image;
  const UserIcon({super.key, required this.iconSize, this.image});

  @override
  Widget build(BuildContext context) {
    String userIcon = image ?? "";

    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: userIcon != ""
          ? ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.memory(
                const Base64Decoder().convert(userIcon),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: const Color.fromARGB(255, 224, 224, 224),
              ),
              child: const Center(
                child: Text("image"),
              ),
            ),
    );
  }
}
