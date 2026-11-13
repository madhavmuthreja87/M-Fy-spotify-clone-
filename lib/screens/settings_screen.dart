import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sf/providers/auth_provider.dart';
import 'package:sf/providers/sign_up_provider.dart';
import 'package:sf/providers/track_provider.dart';
import 'package:sf/screens/onboarding_screen.dart';

class SettingsScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _logout(BuildContext context) async {
    try {
      // Clear profile data
      await context.read<SignUpProvider>().clearUserProfile();

      // Clear music data
      await context.read<TrackProvider>().clearLocalMusicData();

      // Firebase sign out
      await context.read<AuthProvider>().logout();

      if (!context.mounted) return;

      // Navigate to onboarding using ROOT Navigator
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Logout error: $e');

      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Logout failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 68, 68, 68)),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: SizedBox(
              height: 37.7,
              width: 93,
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await _logout(context);
                },
                child: Center(
                  child: Text(
                    "Log out",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
