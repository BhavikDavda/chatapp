import 'package:chatapp/conroller/chat_conrtroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'home_page.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  ChatController controller = Get.put(ChatController());

  void initNotification() {
    flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initNotification();
    FirebaseMessaging.onMessage.listen(
          (event) {
        print("Notification title  => ${event.notification?.title}");
        print("Notification desc   => ${event.notification?.body}");
        controller.showAppNotification(event.notification?.title ?? "", event.notification?.body ?? "");
        // controller.showScheduleAppNotification(event.notification?.title ?? "", event.notification?.body ?? "");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${controller.arg["email"]}"),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.all(12.0),
          //   child: StreamBuilder<DocumentSnapshot>(
          //       stream: FirebaseFirestore.instance
          //           .collection("users")
          //           .doc(controller.arg["reciverId"])
          //           .snapshots(),
          //       builder: (context, snapshot) {
          //         if (snapshot.hasData) {
          //           var otherUser =
          //               snapshot.data?.data() as Map<String, dynamic>;
          //           print("snapshot.data.runtimeType ${otherUser}");
          //           return Row(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               Text((otherUser["isOnline"] == true)
          //                   ? "Online"
          //                   : "Offline"),
          //               Icon(
          //                 Icons.circle,
          //                 size: 12,
          //                 color: (otherUser["isOnline"] == true)
          //                     ? Colors.green
          //                     : Colors.red,
          //               ),
          //             ],
          //           );
          //         } else {
          //           return SizedBox.shrink();
          //         }
          //       }),
          // ),

          IconButton(
              onPressed: () {
                // controller.showScheduleAppNotification("hello ${DateTime.now()}", "All good morning");
                // controller.showBigPictureAppNotification("hello", "Flutter Image");
               // controller.showMediaAppNotification("Hello <b>Bhavik</b>", "Hello <b>Flutter</b>");
                controller.showMediaAppNotification("Hello <b>Bhavik</b>", "Hello <b>Flutter</b>");
              },
              icon: Icon(Icons.notifications))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("message")
                    .orderBy("time")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var msgList = snapshot.data?.docs ?? [];
                    controller.jumpToend();
                    return ListView.builder(
                        controller: controller.scrollController,
                        itemCount: msgList.length,
                        itemBuilder: (context, index) {
                          var msg = msgList[index];
                          Map<String, dynamic> data =
                              msg.data() as Map<String, dynamic>;
                          bool issender = data["sender"] ==
                              FirebaseAuth.instance.currentUser?.uid;
                          if (data['chatRoomId'] !=
                              controller.arg['chatRoomId']) {
                            return SizedBox.shrink();
                          }
                          return Align(
                            alignment: issender
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.sizeOf(context).width / 1.2),
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Text(
                                "${data["msg"]}",
                              ),
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controller.message,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      label: Text("Message"),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    if (controller.message.text.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection("message")
                          .add({
                        "msg": controller.message.text,
                        "time": DateTime.now(),
                        "sender": FirebaseAuth.instance.currentUser?.uid,
                        "chatRoomId": controller.arg["chatRoomId"],
                        "receiver": controller.arg["reciverId"],
                      });
                      controller.message.clear();
                    }
                  },
                  icon: Icon(Icons.send))
            ],
          )
        ],
      ),
    );
  }
}
