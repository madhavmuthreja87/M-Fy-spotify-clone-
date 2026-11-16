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

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(161, 68, 68, 68),
        title: Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Icon(Icons.search, color: Colors.white, size: 27),
          SizedBox(width: 12),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 11),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 72,
                        width: MediaQuery.sizeOf(context).width / 2.2,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(161, 68, 68, 68),
                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.graphic_eq_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                "Data saver mode",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Always off",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 72,
                        width: MediaQuery.sizeOf(context).width / 2.2,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(161, 68, 68, 68),
                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                "Private session",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Off",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20),
              Text(
                "Free account",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10),
              _drawerItem(
                context,
                Icons.person_2_outlined,
                "Account",
                "Username.Close account",
                () {},
              ),

              _drawerItem(
                context,
                Icons.music_note,
                "Content and display",
                "Canvas.Language for music",
                () {},
              ),

              _drawerItem(
                context,
                Icons.lock_clock,
                "Privacy and social",
                "Private session.Public playlists",
                () {},
              ),

              _drawerItem(
                context,
                Icons.campaign_sharp,
                "Playback",
                "Gapeless playback.Autoplay",
                () {},
              ),

              _drawerItem(
                context,
                Icons.notifications,
                "Notifications",
                "Push.Email",
                () {},
              ),

              _drawerItem(
                context,
                Icons.devices,
                "Apps and devices",
                "Google Maps.Import from other apps",
                () {},
              ),

              _drawerItem(
                context,
                Icons.downloading,
                "Data-saving and offline",
                "Data Saver mode.Downloads over cellular",
                () {},
              ),
              _drawerItem(
                context,
                Icons.gradient_sharp,
                "Media quality",
                "Wi-Fi streaming quality.Audio download quality",
                () {},
              ),
              _drawerItem(
                context,
                Icons.add_link_sharp,
                "Advertising",
                "Tailored ads",
                () {},
              ),
              _drawerItem(
                context,
                Icons.info_rounded,
                "About and support",
                "Version.Provacy Policy",
                () {},
              ),

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
              const SizedBox(height: 170),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _drawerItem(
  BuildContext context,
  IconData icon,
  String title,
  String subtitle,
  VoidCallback onTap,
) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    leading: Icon(icon, color: Colors.white, size: 23),
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15.5,
        fontWeight: FontWeight.w500,
      ),
    ),
    subtitle: Text(subtitle),
    onTap: onTap,
    dense: true,
  );
}
