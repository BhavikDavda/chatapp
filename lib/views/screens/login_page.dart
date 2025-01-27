import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../conroller/lofin_controller.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  Lodinconroller controller = Get.put(Lodinconroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Log in"),
      ),
      body: Column(
        children: [
          Obx(() {
            if (controller.isload.value) {
              return CupertinoActivityIndicator(
                radius: 20,
                color: Colors.grey,
              );
            } else {
              return SizedBox.shrink();
            }
          }),
          TextFormField(
            controller: controller.email,
            decoration: InputDecoration(
              hintText: "Email",
              prefixIcon: Icon(Icons.email),
              label: Text("Email"),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controller.password,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.password),
                label: Text("Password"),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      controller.login();
                    },
                    child: Text("Login")),
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      controller.register();
                    },
                    child: Text("regester")),
              ),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);
                try {
                  var act = await _googleSignIn.signIn();
                  print("act ${act?.email}");
                  print("act ${act?.id}");
                } catch (e) {
                  print("google Error $e");
                }
              },
              child: Text("Google login"))
        ],
      ),
    );
  }
}
