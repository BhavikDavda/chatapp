import 'package:chatapp/conroller/home_conroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Homeconroller conroller = Get.put(Homeconroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${FirebaseAuth.instance.currentUser?.email ?? ""}"),
        actions: [
          IconButton(
              onPressed: () {
                Get.changeThemeMode(
                    Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
              },
              icon: Icon(Get.isDarkMode ? Icons.dark_mode : Icons.light)),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, "/");
              },
              icon: Icon(Icons.logout))
        ],
      ),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          onTap: (index) {
            conroller.setmenuind(index);
          },
          currentIndex: conroller.menuindex.value,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
            BottomNavigationBarItem(icon: Icon(Icons.update), label: "update"),
            BottomNavigationBarItem(icon: Icon(Icons.call), label: "call"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Communites"),
          ],
        );
      }),
      body: PageView(
        controller: conroller.pageController,
        onPageChanged: (val) {
          conroller.menuindex.value = val;
        },
        children: [
          Chat(),
          Update(),
          Call(),
          Communiter(),
        ],
      ),
    );
  }
}

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection("chat").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> chatRoom =
                      snapshot.data?.docs ?? [];
                  return ListView.builder(
                    itemCount: chatRoom.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> room = chatRoom[index].data();
                      return ListTile(
                        title: Text("${room["user_b_email"]}"),
                        subtitle: Text("${room["last_msg"]}"),
                        trailing: ((int.tryParse("${room["unread"]}") ?? 0) > 0)
                            ? CircleAvatar(
                                child: Text("${room["unread"]}"),
                              )
                            : null,
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                Get.toNamed("Userspage");
              },
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Call extends StatefulWidget {
  const Call({super.key});

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Communiter extends StatefulWidget {
  const Communiter({super.key});

  @override
  State<Communiter> createState() => _CommuniterState();
}

class _CommuniterState extends State<Communiter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
