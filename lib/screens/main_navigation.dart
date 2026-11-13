import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sf/providers/sign_up_provider.dart';
import 'package:sf/providers/track_provider.dart';

import 'package:sf/screens/home_screen.dart';
import 'package:sf/screens/library_screen.dart';
import 'package:sf/screens/search_screen.dart';
import 'package:sf/screens/downloads_screen.dart';

import 'package:sf/widgets/mini_player.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  // Separate Navigator for each tab
  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  Widget buildTabNavigator({required int index, required Widget screen}) {
    return Navigator(
      key: navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => screen,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sign = context.watch<SignUpProvider>();

    final screens = [
      buildTabNavigator(
        index: 0,
        screen: HomeScreen(
          selectedArtists: sign.artists,
          selectedLanguage: sign.languages.toString(),
          name: sign.username,
        ),
      ),
      buildTabNavigator(index: 1, screen: SearchScreen()),
      buildTabNavigator(index: 2, screen: LibraryScreen()),
      buildTabNavigator(index: 3, screen: DownloadsScreen()),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,

      body: Stack(
        children: [
          // Screens with their own navigation stacks
          IndexedStack(index: currentIndex, children: screens),

          // Bottom gradient
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 250,
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color.fromARGB(120, 0, 0, 0),
                      Color.fromARGB(210, 0, 0, 0),
                    ],
                    stops: [0.0, 0.45, 0.75],
                  ),
                ),
              ),
            ),
          ),

          // Persistent MiniPlayer + Bottom Navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<TrackProvider>(
                    builder: (context, player, child) {
                      if (player.currentSong == null) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: MiniPlayer(
                          song: player.currentSong!,
                          onPlayPause: () {
                            if (player.isPlaying) {
                              player.pause();
                            } else {
                              player.resume();
                            }
                          },
                          onTap: () {
                            // Open your full player screen here
                          },
                        ),
                      );
                    },
                  ),

                  BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: const Color.fromARGB(
                      255,
                      138,
                      138,
                      138,
                    ),
                    currentIndex: currentIndex,
                    selectedFontSize: 11,
                    unselectedFontSize: 10,

                    onTap: (value) {
                      setState(() {
                        currentIndex = value;
                      });
                    },

                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_filled),
                        label: "Home",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search_rounded),
                        label: "Search",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.library_books),
                        label: "Library",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.download),
                        label: "Downloads",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
