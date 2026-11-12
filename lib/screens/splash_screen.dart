import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:sf/screens/main_navigation.dart';
import 'package:sf/screens/onboarding_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this);

  late final User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      body: Center(
        child: Lottie.asset(
          'assets/animations/mfy-splash.json',
          controller: _c,
          width: 600,
          onLoaded: (composition) {
            _c
              ..duration = const Duration(milliseconds: 1750)
              ..forward().whenComplete(() {
                if (!mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) =>
                        user == null ? OnboardingScreen() : MainNavigation(),
                  ),
                );
              });
          },
        ),
      ),
    );
  }
}
