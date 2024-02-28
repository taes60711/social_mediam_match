import 'package:flutter/material.dart';

class IconWithInput extends StatelessWidget {
  final IconData icon;
  final TextEditingController inputController;
  String? hintText;
  double? size;

  IconWithInput(
      {super.key,
      required this.icon,
      required this.inputController,
      this.hintText,
      this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: size ?? 36,
          ),
          Expanded(
            child: SizedBox(
              height: size ?? 36,
              child: TextField(
                controller: inputController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      top: size == null ? 6 : size! - 30,
                      left: 8,
                    ),
                    border: const OutlineInputBorder(),
                    hintText: hintText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
