import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyp/log_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List? _outputs;
  int data = -1;
  File? _image;


  pickImage() async {
    var image =
        await ImagePicker.platform.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    classifyImage(image) ;
  }

  classifyImage(XFile image) async {
    EasyLoading.show();
    var request = http.MultipartRequest('POST', Uri.parse('http://9bce-35-193-116-82.ngrok.io/classify'));
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      EasyLoading.showSuccess("Done");
      EasyLoading.dismiss();
      var prediction = await response.stream.bytesToString();
      var encodedData = jsonDecode(prediction);
      setState(() {
        data = encodedData["result"][0];
      });


    }
    else {
      EasyLoading.showError(response.reasonPhrase.toString());
      EasyLoading.dismiss();
    }

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.blueGrey[900],
          body: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () async {
                      print("hello");
                      await FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LogIn(),
                            ));
                      });
                    },
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ))),
              ),
              Container(
                height: 200,
                width: 200,
                padding: EdgeInsets.only(left: 25, top: 50),
                child: Image.asset("assests/logo.png", fit: BoxFit.cover,),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15,
                    right: 35,
                    left: 35),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: _image == null ? NetworkImage("https://prod-images-static.radiopaedia.org/images/5651/b510dc0d5cd3906018c4dd49b98643.jpg"): FileImage(_image!) as ImageProvider),
                          color: Colors.white54,
                          border:
                              Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            pickImage();
                          },
                          child: Container(
                            child: const Text(
                              "Check Your MRI",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child:  Text(
                       data == -1 ? "Description: Select Image to Predict" : data == 1 ? "Description : Malignant ": "Description : Benign",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
