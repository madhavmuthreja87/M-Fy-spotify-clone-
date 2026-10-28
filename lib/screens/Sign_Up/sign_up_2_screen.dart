import 'package:flutter/material.dart';
import 'package:sf/screens/Sign_Up/sign_up_3_screen.dart';

class SignUp2Screen extends StatefulWidget {
  const new({super.key});

  @override
  State<SignUp2Screen> createState() => _SignUp2ScreenState();
}

class _SignUp2ScreenState extends State<SignUp2Screen> {
  TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25),
              Text(
                "Create a password",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(
                height: 40,
                child: TextField(
                  autofocus: true,
                  cursorColor: Colors.white,
                  controller: passwordController,
                  obscureText: true,

                  textAlignVertical: TextAlignVertical.center,

                  style: TextStyle(color: Colors.white, fontSize: 16),

                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    focusColor: Colors.white,
                    fillColor: const Color.fromARGB(157, 158, 158, 158),
                    filled: true,

                    suffix: Icon(Icons.remove_red_eye),
                  ),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "Use at least 10 characters",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              SizedBox(height: 22),
              Center(
                child: SizedBox(
                  width: 100,
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp3Screen(),
                        ),
                      );
                    },
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
