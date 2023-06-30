import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyp/Modal/UserModal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'log_in.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? image;
  String? imageUrl;

  void pickImage() async {
    EasyLoading.show();
    PermissionStatus permissionResult = await Permission.storage.request();
    if (permissionResult.isGranted) {
      final ImagePicker picker = ImagePicker();
      try {
        var _image = await picker.pickImage(source: ImageSource.gallery);
        setState(() {
          image = File(_image!.path);
        });
        updateImage();
        EasyLoading.showSuccess("Profile Picture Changes");
        EasyLoading.dismiss();
      } catch (e) {
        print(e);
      }
    } else {
      openAppSettings();
    }
  }

  updateImage() async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      print(storageRef.fullPath);
      final imageRef =
          storageRef.child('images/${FirebaseAuth.instance.currentUser!.uid}}');
      await imageRef.putFile(image!).then((p0) {
        const SnackBar snackBar = SnackBar(content: Text('Image Uploaded'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).onError((error, stackTrace) {
        const SnackBar snackBar =
            SnackBar(content: Text('Error Uploading Image'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      imageUrl = await imageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"imgUrl": imageUrl}).then((value) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
          setState(() {
            UserList.userList.clear();
            UserList.userList.add(UserModal.fromSnapshot(value));
          });
        });
      });
    } on FirebaseException catch (e) {
      const SnackBar snackBar = SnackBar(content: Text('Error'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () async {
                          print("Log out");
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
                          print("Log out");
                          await FirebaseAuth.instance.signOut().then((value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LogIn(),
                                ));
                          });
                        },
                        child: Icon(
                          Icons.logout,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () {
                  pickImage();
                },
                child: Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: image == null
                        ? NetworkImage(UserList.userList[0].imgUrl)
                        : FileImage(image!) as ImageProvider,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Field Cannot be Empty";
                  }
                  return null;
                },
                enabled: false,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: UserList.userList[0].name,
                    prefixIcon: const Icon(
                      Icons.person_3_outlined,
                      color: Colors.white,
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Field Cannot be Empty";
                  }
                  return null;
                },
                enabled: false,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: UserList.userList[0].email,
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Field Cannot be Empty";
                  }
                  return null;
                },
                enabled: false,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: UserList.userList[0].cnicNo,
                    prefixIcon: const Icon(
                      Icons.person_2_outlined,
                      color: Colors.white,
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Field Cannot be Empty";
                  }
                  return null;
                },
                enabled: false,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: UserList.userList[0].docType,
                    prefixIcon: const Icon(
                      Icons.security,
                      color: Colors.white,
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Field Cannot be Empty";
                  }
                  return null;
                },
                enabled: false,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: UserList.userList[0].doB,
                    prefixIcon: const Icon(
                      Icons.numbers,
                      color: Colors.white,
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
