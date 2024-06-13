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
                gaplessPlayback: true,
                fit: BoxFit.cover,
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

class SquareUserIcon extends StatelessWidget {
  final double width;
  final double height;
  final String? img;
  const SquareUserIcon({super.key, required this.width, required this.height, this.img});

  @override
  Widget build(BuildContext context) {
    String userIcon = img ?? "";
    return userIcon != ""
        ? SizedBox(
            width: width,
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.memory(
                const Base64Decoder().convert(userIcon),
                gaplessPlayback: true,
                fit: BoxFit.cover,
              ),
            ))
        : Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color.fromARGB(255, 224, 224, 224),
            ),
            child: const Center(
              child: Text("image"),
            ),
          );
  }
}
