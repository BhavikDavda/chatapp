import 'package:chatapp/views/screens/chat_page.dart';
import 'package:chatapp/views/screens/home_page.dart';
import 'package:chatapp/views/screens/login_page.dart';
import 'package:chatapp/views/screens/users_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    themeMode:ThemeMode.system,
    initialRoute: "/",
    getPages: [
      GetPage(name: "/", page: () => Loginpage(),),
      GetPage(name: "/Homepage", page: () => Homepage(),),
      GetPage(name: "/Userspage", page: () => Userspage(),),
      GetPage(name: "/Chatpage", page: () => Chatpage(),)
    ],
  ));
}