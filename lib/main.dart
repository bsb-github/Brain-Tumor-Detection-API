import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyp/firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import '/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DDC());
}

class DDC extends StatelessWidget {
  const DDC({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blueGrey[900],
        listTileTheme: ListTileThemeData(
          textColor: Colors.deepOrangeAccent,
          shape: Border.all(
            color: Colors.deepOrangeAccent,
            width: 2,
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.blueGrey[900],
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
            iconColor: Colors.white,
            hintStyle: TextStyle(color: Colors.white),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.deepOrangeAccent)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white))),
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      builder: EasyLoading.init(),
    );
  }
}
