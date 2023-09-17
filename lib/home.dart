// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fyp/utils/Constants.dart';
import "package:image/image.dart" as img;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyp/HistoryPage.dart';
import 'package:fyp/Profile.dart';
import 'package:fyp/log_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:nanoid/nanoid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String data = "";
  File? _image;
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var logger = Logger();
  bool _isModelLoaded = false;

  pickImage() async {
    var image =
        await ImagePicker.platform.getImage(source: ImageSource.gallery);
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please Pick An Image to Continue")));
      return null;
    }
    setState(() {
      _image = File(image.path);
    });
    _classifyImage();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _classifyImage() async {
    EasyLoading.show(status: 'loading...');
    var url = Uri.parse(Constants.BASE_URL + Constants.MRI_DETECT_URL);
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    var result = jsonDecode(response.body);
    logger.i(result);
    if (result["result"] == "mri") {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Tumor Detected")));
      _classifyTumor();
    } else {
      data = "No Brain MRI Detected";
      EasyLoading.dismiss();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Incorrect Image"),
          content: const Text("No Brain MRI Detected"),
          shadowColor: Colors.deepOrangeAccent,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"))
          ],
        ),
      );
    }
  }

  Future<void> _classifyTumor() async {
    EasyLoading.show(status: 'loading...');
    var url = Uri.parse(Constants.BASE_URL + Constants.CLASSIFICATION_URL);
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    var result = jsonDecode(response.body);
    logger.i(result);
    if (result["result"] == "glioma") {
      EasyLoading.dismiss();
      addHistorytoFirebase("Benign: Glioma Tumor");
      data = "Glioma Tumor";
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(
            "Glioma Tumor",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueGrey[900],
          shadowColor: Colors.deepOrangeAccent,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(_image!), fit: BoxFit.cover)),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Glioma is a type of tumor that occurs in the brain and spinal cord. Gliomas begin in the gluey supportive cells (glial cells) that surround nerve cells and help them function. The symptoms and treatment options for gliomas depend on the type and location of the glioma.",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // create button to pop up the dialog

            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _nameController.clear();
                  _image = null;
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepOrangeAccent)),
                child: Text("Ok"),
              ),
            )
          ],
        ),
      );
    } else if (result["result"] == "pituitary") {
      data = "Pituitary Tumor";
      EasyLoading.dismiss();
      addHistorytoFirebase("Malignant: Pituitary Tumor");
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(
            "Pituitary Tumor",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueGrey[900],
          shadowColor: Colors.deepOrangeAccent,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(_image!), fit: BoxFit.cover)),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Pituitary tumors are abnormal growths that develop in your pituitary gland. Some pituitary tumors result in too many of the hormones that regulate important functions of your body. Some pituitary tumors can cause your pituitary gland to produce lower levels of hormones.",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // create button to pop up the dialog

            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _nameController.clear();
                  _image = null;
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepOrangeAccent)),
                child: Text("Ok"),
              ),
            )
          ],
        ),
      );
    } else if (result["result"] == "meningioma") {
      EasyLoading.dismiss();
      data = "Meningioma Tumor";
      addHistorytoFirebase("Malignant: Meningioma Tumor");
      showDialog(
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SimpleDialog(
            shadowColor: Colors.deepOrangeAccent,
            title: Text(
              "Meningioma Tumor",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blueGrey[900],
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(_image!), fit: BoxFit.cover)),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Meningioma is a tumor that arises from the meninges — the membranes that surround your brain and spinal cord. Although not technically a brain tumor, it is included in this category because it may compress or squeeze the adjacent brain, nerves and vessels.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // create button to pop up the dialog

              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _nameController.clear();
                    _image = null;
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepOrangeAccent)),
                  child: Text("Ok"),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      EasyLoading.dismiss();
      data = "No Tumor Detected";
      addHistorytoFirebase("No Tumor");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.blueGrey[900],
          shadowColor: Colors.deepOrangeAccent,
          title: const Text(
            "No Tumor Detected",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "No Tumor Detected",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _nameController.clear();
                  _image = null;
                },
                child: const Text("Ok"))
          ],
        ),
      );
    }
  }

  Future<String> updateImage(String imagePath) async {
    File image = File(imagePath);
    var id = nanoid(10);
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('images/$id}');
      await imageRef.putFile(image!).then((p0) {
        const SnackBar snackBar = SnackBar(content: Text('Image Uploaded'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).onError((error, stackTrace) {
        const SnackBar snackBar =
            SnackBar(content: Text('Error Uploading Image'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      String imageUrl = await imageRef.getDownloadURL();
      return imageUrl;
    } on FirebaseException catch (e) {
      const SnackBar snackBar =
          SnackBar(content: Text('Error Uploading Image'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return "";
    }
  }

  addHistorytoFirebase(String result) async {
    var user = FirebaseAuth.instance.currentUser;
    var id = nanoid(10);
    var name = _nameController.text;
    var imageUrl = await updateImage(_image!.path);
    var user_data = {
      "id": id,
      "name": name,
      "image": imageUrl,
      "result": result,
      "date": DateTime.now().toString()
    };
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("history")
        .doc(id)
        .set(user_data);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.blueGrey[900],
          body: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profile(),
                              ));
                        },
                        child: Icon(
                          Icons.person_2_outlined,
                          color: Colors.white,
                        )),
                  ),
                  Container(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HistoryPage(),
                              ));
                        },
                        child: Icon(
                          Icons.history,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
              Container(
                height: 300,
                width: 300,
                padding: EdgeInsets.only(left: 25, top: 50),
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.cover,
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextFormField(
                    controller: _nameController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Field Cannot be Empty";
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Patient Name",
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white))),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(right: 35, left: 35),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: _image == null
                                  ? NetworkImage(
                                      "https://prod-images-static.radiopaedia.org/images/5651/b510dc0d5cd3906018c4dd49b98643.jpg")
                                  : FileImage(_image!) as ImageProvider),
                          color: Colors.white54,
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              pickImage();
                            }
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.sizeOf(context).width * 0.5,
                            decoration: BoxDecoration(
                                color: Colors.deepOrangeAccent,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: const Text(
                                "Pick Your MRI",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
