import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Userspage extends StatefulWidget {
  const Userspage({super.key});

  @override
  State<Userspage> createState() => _UserspageState();
}

class _UserspageState extends State<Userspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").get().asStream(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            List users = snapshot.data?.docs ?? [];
            return ListView.builder(
                itemCount: users.length,
                itemBuilder:(context,index){
                  var user = users[index];
                  return ListTile(
                    title: Text("${user["email"]}"),
                    onTap: ()async{
                      var chatRoom= await FirebaseFirestore.instance.collection("chat").
                      where("users_a", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .where("users_b", isEqualTo: user["id"]);

                   QuerySnapshot<Map<String,dynamic>> data = await chatRoom.get();

                   String chatRoomId = "";

                   if(data.docs.isEmpty) {
                     DocumentReference dataAdded = await FirebaseFirestore
                         .instance.collection("chat").add(
                         {
                           "users_a": FirebaseAuth.instance.currentUser?.uid,
                           "users_b": user["id"],
                           "users": [
                             FirebaseAuth.instance.currentUser?.uid,
                             user["id"]
                           ],
                           "last_message": "",
                         }
                     );
                     var chatref = await dataAdded.get();
                     chatRoomId = chatref.id;
                   }else{
                     chatRoomId = data.docs.first.id;
                   }

                   Get.toNamed("Chatpage",arguments: {
                     "email" : "${user["email"]}",
                     "chatRoomId" : chatRoomId,
                     "reciverId" : user["id"],
                   });


                    },
                  );

                }
            );

          }else{
            return Center(
              child: CupertinoActivityIndicator(
                radius: 20,
                color: Colors.grey,
              ),
            );
          }

        }
      )
    );
  }
}
