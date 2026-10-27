import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              Column(
                children: [
                  SizedBox(height: 40),
                  SizedBox(
                    height: 180,
                    width: 180,
                    child: Image.asset('assets/icons/mfy-logo.png'),
                  ),
                  Text(
                    "Millions of songs.",
                    style: TextStyle(
                      fontSize: 37.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Free on M-Fy.",
                    style: TextStyle(
                      fontSize: 37.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 47.5,
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          97,
                          225,
                          101,
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Sign up for free",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 47.5,
                    width: double.infinity,

                    child: TextButton(
                      style: TextButton.styleFrom(
                        side: BorderSide(color: Colors.grey),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Log in",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
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
