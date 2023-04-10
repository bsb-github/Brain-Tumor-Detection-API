import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fyp/home.dart';
import '/log_in.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
    Timer(Duration(seconds: 6), () {
      checkCurrentUser();
    });
  }

  void checkCurrentUser() async {
    if (await FirebaseAuth.instance.currentUser == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LogIn(),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Icon(
              Icons.android_outlined,
              size: 150,
            ),
          ),
          AnimatedTextKit(animatedTexts: [
            TyperAnimatedText('Welcome To My App'),
            TyperAnimatedText('you must know what to do,'),
            TyperAnimatedText('and then do your best'),
          ]),
        ],
      ),
    );
  }
}
