import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sf/providers/sign_up_provider.dart';
import 'package:sf/screens/Sign_Up/sign_up_4_screen.dart';

class SignUp3Screen extends StatefulWidget {
  const new({super.key});

  @override
  State<SignUp3Screen> createState() => _SignUp3ScreenState();
}

class _SignUp3ScreenState extends State<SignUp3Screen> {
  DateTime selectedDate = DateTime(2016, 11, 26);
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
              "What's you date of birth?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 170,

              child: CupertinoDatePicker(
                dateOrder: DatePickerDateOrder.dmy,
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selectedDate,

                maximumDate: DateTime.now(),
                minimumDate: DateTime(1900),
                onDateTimeChanged: (date) {
                  selectedDate = date;
                },
              ),
            ),

            SizedBox(height: 65),
            Center(
              child: SizedBox(
                height: 50,
                width: 100,
                child: TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    context.read<SignUpProvider>().setDOB(selectedDate);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp4Screen()),
                    );
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
