import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sf/providers/sign_up_provider.dart';
import 'package:sf/screens/Sign_Up/sign_up_3_screen.dart';
import 'package:sf/providers/auth_provider.dart';
import 'package:sf/widgets/loading_screen.dart';

class SignUp2Screen extends StatefulWidget {
  final String email;
  const SignUp2Screen({super.key, required this.email});

  @override
  State<SignUp2Screen> createState() => _SignUp2ScreenState();
}

class _SignUp2ScreenState extends State<SignUp2Screen> {
  TextEditingController passwordController = TextEditingController();
  bool hidepassword = true;
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
                height: 45,
                child: TextField(
                  autofocus: true,
                  cursorColor: Colors.white,
                  controller: passwordController,
                  obscureText: hidepassword,

                  textAlignVertical: TextAlignVertical.center,

                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    isDense: true,

                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    focusColor: Colors.white,
                    fillColor: const Color.fromARGB(157, 158, 158, 158),
                    filled: true,

                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          hidepassword = !hidepassword;
                        });
                      },
                      icon: Icon(
                        size: 25,
                        hidepassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                    ),
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
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Loading(),
                        ),
                      );

                      // Give Flutter time to display the loading screen
                      await Future.delayed(const Duration(milliseconds: 100));

                      if (!mounted) return;

                      // Create account while Loading screen is visible
                      final success = await context.read<AuthProvider>().signUp(
                        widget.email,
                        passwordController.text.trim(),
                      );

                      if (!mounted) return;

                      // Remove Loading screen
                      Navigator.pop(context);

                      if (success) {
                        context.read<SignUpProvider>().setEmail(widget.email);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp3Screen(),
                          ),
                        );
                      }
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
