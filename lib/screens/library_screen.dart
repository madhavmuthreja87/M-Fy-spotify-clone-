import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sf/providers/sign_up_provider.dart';
import 'package:sf/services/audis_api.dart';
import 'package:sf/providers/track_provider.dart';
import 'package:sf/screens/create_playlist.dart';
import 'package:sf/screens/liked_songs.dart';
import 'package:sf/screens/playlist_home.dart';

class LibraryScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        child: Text("M"),
                        backgroundColor: Colors.orange,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your Library",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  size: 32,
                                  Icons.search_outlined,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () => {
                                    log("create playlist icon tapped"),
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreatePlaylist(),
                                      ),
                                    ),
                                  },
                                  child: Icon(
                                    size: 40,
                                    Icons.add_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Text(
                          "Playlists",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Text(
                          "Albums",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Text(
                          "Artists",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            child: Container(
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_upward, color: Colors.white),
                                  Icon(
                                    Icons.arrow_downward,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Recents",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.grid_view, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                            ) => const LikedSongs(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  final curvedAnimation = CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInQuad,
                                  );

                                  return FadeTransition(
                                    opacity: curvedAnimation,
                                    child: ScaleTransition(
                                      scale: Tween<double>(
                                        begin: 0.95,
                                        end: 1.0,
                                      ).animate(curvedAnimation),
                                      child: child,
                                    ),
                                  );
                                },
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,

                          leading: Container(
                            height: 60,
                            width: 60,

                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.deepPurple, Colors.white],
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Icon(Icons.favorite, color: Colors.white),
                            ),
                          ),
                          title: Text(
                            "Liked Songs",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          subtitle: Row(
                            children: [
                              Icon(
                                Icons.push_pin_rounded,
                                color: Colors.green,
                                size: 20,
                              ),
                              Text(
                                " Playlist • Username",
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    159,
                                    159,
                                    159,
                                  ),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //
                  Consumer<TrackProvider>(
                    builder: (context, tracker, child) {
                      final playlists = tracker.allplaylistsName();
                      return ListView.builder(
                        itemCount: tracker.allplaylistsName().length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,

                        itemBuilder: (context, index) {
                          final playlistname = tracker
                              .allplaylistsName()[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PlaylistHome(pname: playlistname),
                                ),
                              );
                            },
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,

                              leading: Container(
                                height: 62,
                                width: 62,

                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.headphones,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              title: Text(
                                playlistname,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    " Playlist • Username",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        159,
                                        159,
                                        159,
                                      ),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Consumer<SignUpProvider>(
                    builder: (context, provider, child) {
                      final artists = provider.artistsList();

                      return ListView.builder(
                        itemCount: artists.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final artistElement = artists[index];

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            hoverColor: Colors.green,
                            leading: const CircleAvatar(
                              radius: 25,
                              child: Icon(Icons.person_3),
                            ),
                            title: Text(
                              artistElement['name'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: const Text(
                              "Artist",
                              style: TextStyle(
                                color: Color.fromARGB(255, 159, 159, 159),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // ListTile(
                  //   contentPadding: EdgeInsets.zero,
                  //   hoverColor: Colors.green,
                  //   leading: CircleAvatar(
                  //     child: Icon(Icons.person),
                  //     radius: 25,
                  //   ),
                  //   title: Text(
                  //     "Karan Aujhla",
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   subtitle: Row(
                  //     children: [
                  //       Text(
                  //         "Artist",
                  //         style: TextStyle(
                  //           color: const Color.fromARGB(255, 159, 159, 159),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // ListTile(
                  //   contentPadding: EdgeInsets.zero,
                  //   hoverColor: Colors.green,
                  //   leading: CircleAvatar(
                  //     child: Icon(Icons.person_2),
                  //     radius: 25,
                  //   ),
                  //   title: Text(
                  //     "Paradox",
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   subtitle: Row(
                  //     children: [
                  //       Text(
                  //         "Artist",
                  //         style: TextStyle(
                  //           color: const Color.fromARGB(255, 159, 159, 159),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // ListTile(
                  //   contentPadding: EdgeInsets.zero,
                  //   hoverColor: Colors.green,
                  //   leading: CircleAvatar(
                  //     child: Icon(Icons.person_3),
                  //     radius: 25,
                  //   ),
                  //   title: Text(
                  //     "Shubh",
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   subtitle: Row(
                  //     children: [
                  //       Text(
                  //         "Artist",
                  //         style: TextStyle(
                  //           color: const Color.fromARGB(255, 159, 159, 159),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Consumer<SignUpProvider>(builder: builder),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
