import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sf/models/auth_model.dart';
import 'package:sf/providers/sign_up_provider.dart';
import 'package:sf/screens/Sign_Up/sign_up_6_screen.dart';
import 'package:sf/widgets/loading_screen.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SignUp5Screen extends StatefulWidget {
  const new({super.key});

  @override
  State<SignUp5Screen> createState() => _SignUp5ScreenState();
}

class _SignUp5ScreenState extends State<SignUp5Screen> {
  TextEditingController nameController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = context.read<SignUpProvider>().email.split('@').first;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            "Create account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25),
                  Text(
                    "What's you name?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(
                    height: 60,
                    child: TextField(
                      // autofocus: true,
                      cursorColor: Colors.white,
                      controller: nameController,

                      textAlignVertical: TextAlignVertical.center,

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorRadius: Radius.circular(20),
                      decoration: InputDecoration(
                        isDense: true,

                        border: InputBorder.none,

                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusColor: Colors.white,

                        fillColor: const Color.fromARGB(157, 158, 158, 158),
                        filled: true,

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: 3),
                  Text(
                    "This appears on your M-Fy profile.",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),

                  SizedBox(height: 15),
                  Divider(
                    height: 0.1,
                    color: const Color.fromARGB(160, 158, 158, 158),
                  ),
                  SizedBox(height: 28),
                  Text(
                    "This appears on your M-Fy profile.",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(height: 21),
                  Text(
                    "By tapping Create account, you agree to the M-Fy Terms of Use.",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(height: 21),
                  Text(
                    "Term of Use",
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                  SizedBox(height: 21),
                  Text(
                    "By tapping Create account, you confirm that you have read how we process your personal data in our Privacy Policy",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(height: 21),
                  Text(
                    "Privacy Policy",
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                  SizedBox(height: 21),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Loading()),
                        );

                        try {
                          final signup = context.read<SignUpProvider>();
                          final firebaseUser =
                              FirebaseAuth.instance.currentUser;

                          if (firebaseUser == null) {
                            throw Exception('User not logged in');
                          }

                          final authmodel = AuthModel(
                            UID: firebaseUser.uid,
                            name: signup.name,
                            email: signup.email,
                            pic: signup.pic,
                            gender: signup.gender,
                            username: signup.email.split('@').first,
                            dob: signup.dob ?? DateTime.now(),
                            languages: signup.languages,
                            artists: signup.artists,
                            genres: signup.genres,
                          );

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(
                                "${signup.email.split('@').first}__${firebaseUser.uid.substring(0, 3)}",
                              )
                              .set(authmodel.toMap());

                          if (!context.mounted) return;

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp6Screen(),
                            ),
                          );
                        } catch (e) {
                          if (!context.mounted) return;

                          Navigator.pop(context); // Close loading screen

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to save profile: $e'),
                            ),
                          );
                        }
                      },

                      child: Text(
                        "Create account",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
