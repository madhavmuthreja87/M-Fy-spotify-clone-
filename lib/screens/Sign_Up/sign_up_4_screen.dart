import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sf/providers/sign_up_provider.dart';
import 'package:sf/screens/Sign_Up/sign_up_5_screen.dart';

class SignUp4Screen extends StatefulWidget {
  const new({super.key});

  @override
  State<SignUp4Screen> createState() => _SignUp4ScreenState();
}

class _SignUp4ScreenState extends State<SignUp4Screen> {
  String? selectedGender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Text(
              "What's your gender?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selectedGender == 'Female'
                        ? const Color(0xFF1ED760)
                        : const Color(0xFF292929),
                    foregroundColor: selectedGender == 'Female'
                        ? Colors.black
                        : Colors.white,
                    side: BorderSide(
                      color: selectedGender == 'Female'
                          ? const Color(0xFF1ED760)
                          : const Color.fromARGB(255, 135, 135, 135),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedGender = 'Female';
                    });
                    context.read<SignUpProvider>().setGender(selectedGender!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp5Screen()),
                    );
                  },
                  child: const Text('Female'),
                ),
                SizedBox(width: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selectedGender == 'Male'
                        ? const Color(0xFF1ED760)
                        : const Color(0xFF292929),
                    foregroundColor: selectedGender == 'Male'
                        ? Colors.black
                        : Colors.white,
                    side: BorderSide(
                      color: selectedGender == 'Male'
                          ? const Color(0xFF1ED760)
                          : Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedGender = 'Male';
                    });
                    context.read<SignUpProvider>().setGender(selectedGender!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp5Screen()),
                    );
                  },
                  child: const Text('Male'),
                ),
                SizedBox(width: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selectedGender == 'Non-binary'
                        ? const Color(0xFF1ED760)
                        : const Color(0xFF292929),
                    foregroundColor: selectedGender == 'Non-binary'
                        ? Colors.black
                        : Colors.white,
                    side: BorderSide(
                      color: selectedGender == 'Non-binary'
                          ? const Color(0xFF1ED760)
                          : Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedGender = 'Non-binary';
                    });
                    context.read<SignUpProvider>().setGender(selectedGender!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp5Screen()),
                    );
                  },
                  child: const Text('Non-binary'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selectedGender == 'Other'
                        ? const Color(0xFF1ED760)
                        : const Color(0xFF292929),
                    foregroundColor: selectedGender == 'Other'
                        ? Colors.black
                        : Colors.white,
                    side: BorderSide(
                      color: selectedGender == 'Other'
                          ? const Color(0xFF1ED760)
                          : Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedGender = 'Other';
                    });
                    context.read<SignUpProvider>().setGender(selectedGender!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp5Screen()),
                    );
                  },
                  child: const Text('Other'),
                ),
                SizedBox(width: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selectedGender == 'Prefer not to say'
                        ? const Color(0xFF1ED760)
                        : const Color(0xFF292929),
                    foregroundColor: selectedGender == 'Prefer not to say'
                        ? Colors.black
                        : Colors.white,
                    side: BorderSide(
                      color: selectedGender == 'Prefer not to say'
                          ? const Color(0xFF1ED760)
                          : Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedGender = 'Prefer not to say';
                    });
                    context.read<SignUpProvider>().setGender(selectedGender!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp5Screen()),
                    );
                  },
                  child: const Text('Prefer not to say'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
