import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sf/providers/sign_up_provider.dart';
import 'package:sf/screens/recents_in_drawer.dart';
import 'package:sf/screens/settings_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SignUpProvider>();

    final String displayName = user.name.isNotEmpty ? user.name : 'Music Lover';

    return Drawer(
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      // width: MediaQuery.of(context).size.width * 0.82,

      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PROFILE HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 16, 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color.fromARGB(255, 236, 175, 85),
                    child: Text(
                      displayName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Text(
                        //   user.email,
                        //   style: const TextStyle(
                        //     color: Colors.grey,
                        //     fontSize: 12,
                        //   ),
                        // ),
                        const Text(
                          'View profile',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ),

            // MAIN MENU
            _drawerItem(
              context,
              Icons.auto_graph,
              'Listening stats',
              () => Navigator.pop(context),
            ),

            _drawerItem(context, Icons.timer_sharp, 'Recents', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecentsInDrawer()),
              );
              // Navigate to SearchScreen
            }),

            _drawerItem(context, Icons.campaign_outlined, 'Your Updates', () {
              Navigator.pop(context);
              // Navigate to LibraryScreen
            }),

            _drawerItem(
              context,
              Icons.settings_sharp,
              'Settings and privacy',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
                // Navigate to RecentsScreen
              },
            ),
            const Spacer(),

            const Divider(color: Colors.grey, thickness: 0.6),
            Padding(padding: EdgeInsetsGeometry.only(top: 40)),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 22),
      leading: Icon(icon, color: Colors.white, size: 23),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      dense: true,
    );
  }
}
