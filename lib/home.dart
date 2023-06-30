import 'dart:convert';
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
import 'package:nanoid/nanoid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int data = -1;
  File? _image;
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    classifyImage(image.path);
  }

  classifyImage(String imagePath) async {
    EasyLoading.show();
    var request = http.MultipartRequest('POST',
        Uri.parse('https://fathomless-journey-56046.herokuapp.com/classify'));
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      EasyLoading.showSuccess("Done");
      EasyLoading.dismiss();
      var prediction = await response.stream.bytesToString();
      var encodedData = jsonDecode(prediction);
      print(encodedData);
      setState(() {
        data = encodedData["result"][0];
      });
      await addHistorytoFirebase();
      setState(() {
        data = -1;
        _image = null;
        _nameController.text = "";
      });
    } else {
      EasyLoading.showError(response.reasonPhrase.toString());
      EasyLoading.dismiss();
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

  addHistorytoFirebase() async {
    var user = FirebaseAuth.instance.currentUser;
    var id = nanoid(10);
    var name = _nameController.text;
    var imageUrl = await updateImage(_image!.path);
    var data = {
      "id": id,
      "name": name,
      "image": imageUrl,
      "result": !(this.data == "1") ? "Malignant" : "Benign",
      "date": DateTime.now().toString()
    };
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("history")
        .doc(id)
        .set(data);
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
                height: 200,
                width: 200,
                padding: EdgeInsets.only(left: 25, top: 50),
                child: Image.asset(
                  "assests/logo.png",
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
                            child: const Text(
                              "Pick Your MRI",
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
                      child: Text(
                        data == -1
                            ? "Description: Select Image to Predict"
                            : data == 1
                                ? "Description : Malignant "
                                : "Description : Benign",
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
