import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Lodinconroller extends GetxController {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  RxBool isload = false.obs;

  Future<void> login() async {

    isload.value = true;

    try {
      UserCredential userCred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email.text,
          password: password.text);
      Get.offAllNamed("Homepage");
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Eroor", e.code);
    }
     isload.value = false;
  }


  Future<void> register()async{
    isload.value = true;
    try{
      UserCredential userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text);
      if(userCred.user != null ){
         await FirebaseFirestore.instance.collection("users").add(
          {
            "id" : userCred.user?.uid,
            "email" : userCred.user?.email??""
          }
         );
         Get.offAllNamed("Homepage");
         }
      }on FirebaseAuthException catch(e){
      Get.snackbar("Eroor", e.code);
    }
    isload.value = false;
  }

}
