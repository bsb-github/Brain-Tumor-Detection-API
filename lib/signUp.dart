import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[900],
        body: Column(
          children: [
            SafeArea(
              child: Container(
                  height: 200,
                  width: 200,
                  padding: EdgeInsets.only(left: 35, top: 130),
                  child: Image.asset(
                    "assests/logo.png",
                    fit: BoxFit.cover,
                  )),
            ),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2,
                      right: 35,
                      left: 35),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userNameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "User Name",
                            prefixIcon: const Icon(
                              Icons.verified_user,
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: const Icon(
                              Icons.password,
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                EasyLoading.show();
                                try {
                                  FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: emailController.text,
                                          password: passwordController.text)
                                      .then((user) async {
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(user.user!.uid)
                                        .set({
                                      "name": userNameController.text,
                                      "email": emailController.text,
                                    });
                                  }).then((value) {
                                    FirebaseAuth.instance.signOut();
                                    EasyLoading.showSuccess(
                                        "You can now login");

                                    EasyLoading.dismiss();
                                  });
                                } on FirebaseAuthException catch (e) {
                                  EasyLoading.showError(e.code);
                                  EasyLoading.dismiss();
                                }
                              }
                            },
                            child: Container(
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Already a user ?",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
