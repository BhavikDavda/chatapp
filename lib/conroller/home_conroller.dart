import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Homeconroller extends GetxController{

  PageController pageController = PageController();
  late AppLifecycleListener appLifecycleListener;

  RxInt menuindex = 0.obs;
  late Map<String, dynamic>arg;


  void setmenuind(int index){
    menuindex.value = index;
    pageController.jumpToPage(index);


  }
  @override
  void onInit() {
    super.onInit();
    appLifecycleListener = AppLifecycleListener(
        onStateChange: (value) {
          if(value == AppLifecycleState.resumed){
            FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).update({
              "isOnline" : true,
            });

          }else if(value == AppLifecycleState.paused){
            FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).update({
              "isOnline" : false,
            });

          }
        }
    );
    updatefirebaseToken();
  }

  Future<void> updatefirebaseToken()async{
   String? token = await FirebaseMessaging.instance.getToken();
   print("token =======> $token");
   FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).update({
     "Token" : token
   });
  }



}