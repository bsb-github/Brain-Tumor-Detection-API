import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  final doBController = TextEditingController();
  final cnicController = TextEditingController();
  String docType = "Private";

  final _formKey = GlobalKey<FormState>();
  @override
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
                      "assets/logo.png",
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
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.10,
                      right: 35,
                      left: 35),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userNameController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Field Cannot be Empty";
                          }
                          return null;
                        },
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
                        controller: doBController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          MultiMaskedTextInputFormatter(masks: [
                            "xx-xx-xxxx",
                            "xxxx-xx-xx",
                          ], separator: "-")
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "CNIC No cannot be empty";
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "99-02-20 or 1999-02-20",
                            prefixIcon: const Icon(
                              Icons.calendar_month,
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
                        controller: cnicController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          MultiMaskedTextInputFormatter(
                              masks: ["xxxxx-xxxxxxx-x"], separator: "-")
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "CNIC No cannot be empty";
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "11111-1111111-1",
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownSearch(
                        selectedItem: "Private",
                        onChanged: (value) {
                          setState(() {
                            docType = value!;
                          });
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                            baseStyle: TextStyle(color: Colors.white)),
                        items: ["Private", "Government"],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      docType == "Government"
                          ? TextFormField(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Field Cannot be Empty";
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  hintText: "Rank",
                                  prefixIcon: const Icon(
                                    Icons.password,
                                    color: Colors.white,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            )
                          : SizedBox(),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController,
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
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Field Cannot be Empty";
                          } else if (val != passwordController.text) {
                            return "Password doesn't match";
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Confirm Password",
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
                                      "doB": doBController.text,
                                      "cnicNo": cnicController.text,
                                      "docType": docType,
                                      "imgUrl":
                                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png",
                                    });
                                  }).then((value) {
                                    FirebaseAuth.instance.signOut();
                                    EasyLoading.showSuccess(
                                        "You can now login");
                                    EasyLoading.dismiss();
                                    Navigator.pop(context);
                                  });
                                } on FirebaseAuthException catch (e) {
                                  EasyLoading.showError(e.code);
                                  EasyLoading.dismiss();
                                }
                              }
                            },
                            child: Container(
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.deepOrangeAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 80,
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
                                    style: TextStyle(
                                        color: Colors.deepOrangeAccent),
                                  )),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
