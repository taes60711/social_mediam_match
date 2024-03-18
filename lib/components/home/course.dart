import 'package:flutter/material.dart';

import '../../states/services/notification_service.dart';

class Course extends StatelessWidget {
  const Course({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ElevatedButton(
        onPressed: () {
          NotificationService().sendNotification(
              message: "消息",
              sendto:
                  "c-K6UQ-LSlS44Ymc6H1cJh:APA91bH1SHXOOWIj3xW1KYWAOB4V5PTu9L0Yd0pqZ1qYtl99EhbmVsdY0ESgco7pwYYS0RLDCCXHHATGqmPXUPAHxAfeJngw7nuQ1ml92rx0ORueiZR8ofS8Yd1xDVmlJ6KGvkVyKfwJ");
        },
        child: Text("asdad"),
      ),
    );
  }
}
