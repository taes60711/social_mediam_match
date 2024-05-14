import 'package:flutter/material.dart';

class CourseEditPage extends StatelessWidget {
  const CourseEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("exit"),
            )
          ],
        ),
      ),
    );
  }
}
