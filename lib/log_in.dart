import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyp/Modal/UserModal.dart';
import 'package:fyp/signUp.dart';
import '/home.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[900],
        body: SingleChildScrollView(
          child: Column(
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
              const SizedBox(
                height: 50,
              ),
              Text(
                "Disease Detection Using CNN",
                style: TextStyle(fontSize: 24, color: Colors.deepOrangeAccent),
              ),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.18,
                        right: 35,
                        left: 35),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Field Cannot be Empty";
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon: const Icon(
                                Icons.verified_user,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Field Cannot be Empty";
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: const Icon(
                                Icons.password,
                                color: Colors.white,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                // lOGIN fUNCTION
                                if (_formKey.currentState!.validate()) {
                                  EasyLoading.show();
                                  try {
                                    FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: _emailController.text,
                                            password: _passwordController.text)
                                        .then((value) async {
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .get()
                                          .then((value) {
                                        UserList.userList.clear();
                                        UserList.userList
                                            .add(UserModal.fromSnapshot(value));
                                      });
                                      EasyLoading.showSuccess("Success");
                                      EasyLoading.dismiss();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeScreen(),
                                          ));
                                    });
                                  } on FirebaseException catch (e) {
                                    EasyLoading.showError(e.code);
                                    EasyLoading.dismiss();
                                  }
                                }
                              },
                              child: Container(
                                child: const Text(
                                  "Log In",
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
                                  "Not a user ?",
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SignUp(),
                                          ));
                                    },
                                    child: Text(
                                      "SignUp",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
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
          ),
        ));
  }
}
