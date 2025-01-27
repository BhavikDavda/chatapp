import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../views/screens/home_page.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  TextEditingController message = TextEditingController();
  ScrollController scrollController = ScrollController();

  void jumpToend() {
    Future.delayed(Duration(milliseconds: 200), () {
      var maxScrollExtent = scrollController.position.maxScrollExtent;
      scrollController.jumpTo(maxScrollExtent);
    });
  }

  late Map<String, dynamic> arg;

  @override
  void onInit() {
    super.onInit();
    arg = Get.arguments;
  }



  void showAppNotification(String title, String desc) async {
    flutterLocalNotificationsPlugin.show(
      0,
      title,
      desc,
      NotificationDetails(
        android: AndroidNotificationDetails(
          "Chat",
          "ChatApp",
        ),
      ),
    );
  }

  void showScheduleAppNotification(String title, String desc) async {
    flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      desc,
      tz.TZDateTime.now(tz.local).add(Duration(minutes: 2)),
      // tz.TZDateTime(tz.local, 2025,1,20,10,30),
      NotificationDetails(
        android: AndroidNotificationDetails(
          "Chat",
          "ChatApp",
          icon: "@mipmap/ic_launcher",
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  void showBigPictureAppNotification(String title, String desc) async {
    var uint8List =
    await _getByteArrayFromUrl("https://cdn.prod.website-files.com/654366841809b5be271c8358/659efd7c0732620f1ac6a1d6_why_flutter_is_the_future_of_app_development%20(1).webp");
    flutterLocalNotificationsPlugin.show(
      0,
      title,
      desc,
      NotificationDetails(
        android: AndroidNotificationDetails(
          "Chat",
          "ChatApp",
          styleInformation: BigPictureStyleInformation(ByteArrayAndroidBitmap(uint8List)),
        ),
      ),
    );
  }

  void showMediaAppNotification(String title, String desc) async {
    flutterLocalNotificationsPlugin.show(
      0,
      title,
      desc,
      NotificationDetails(
        android: AndroidNotificationDetails(
          "Chat",
          "ChatApp",
          styleInformation: MediaStyleInformation(
            htmlFormatContent: true,
            htmlFormatTitle: true,
          ),
        ),
      ),
    );
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }
}
