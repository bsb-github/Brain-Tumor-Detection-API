import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/home.dart';
import '/log_in.dart';
import 'Modal/UserModal.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //FirebaseAuth.instance.signOut();
    Timer(const Duration(seconds: 4), () {
      checkCurrentUser();
    });
  }

  void checkCurrentUser() async {
    if ((FirebaseAuth.instance.currentUser == null)) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LogIn(),
          ));
    } else {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        UserList.userList.clear();
        UserList.userList.add(UserModal.fromSnapshot(value));
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.asset("assests/logo.png")),
          const SizedBox(
            height: 50,
          ),
          Text(
            "Disease Detection Using CNN",
            style: TextStyle(fontSize: 24, color: Colors.deepOrangeAccent),
          )
        ],
      ),
    );
  }
}
