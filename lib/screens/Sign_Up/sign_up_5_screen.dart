import 'package:flutter/material.dart';

class SignUp5Screen extends StatefulWidget {
  const new({super.key});

  @override
  State<SignUp5Screen> createState() => _SignUp5ScreenState();
}

class _SignUp5ScreenState extends State<SignUp5Screen> {
  TextEditingController nameController = TextEditingController();
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
                      autofocus: true,
                      cursorColor: Colors.white,
                      controller: nameController,

                      textAlignVertical: TextAlignVertical.center,

                      style: TextStyle(color: Colors.white, fontSize: 16),
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
                          horizontal: 4,
                          vertical: 12,
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
                      onPressed: () {},
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
