import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sf/providers/track_provider.dart';
import 'package:sf/models/track_model.dart';
import 'package:sf/screens/liked_songs.dart';

class HomeScreen extends StatefulWidget {
  final List<String> selectedArtists;
  final String selectedLanguage;

  const HomeScreen({
    super.key,
    required this.selectedArtists,
    required this.selectedLanguage,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    print("HOME ARTISTS: ${widget.selectedArtists}");
    print("HOME LANGUAGE: ${widget.selectedLanguage}");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tracker = context.read<TrackProvider>();

      // // Fetch personalised songs
      // tracker.fetchInitialHomeSongs(
      //   selectedArtists: widget.selectedArtists,
      //   selectedLanguages: widget.selectedLanguage,
      // );

      // Fetch trending songs
      tracker.fetchTrendingSongs();
    });
  }

  // Convert most-played/recent Map data into TrackModel
  TrackModel trackFromMap(Map element) {
    return TrackModel(
      id: element['id']?.toString() ?? '',
      title: element['title']?.toString() ?? '',
      artist: element['artist']?.toString() ?? '',
      duration:
          (element['duration'] as num?)?.toInt() ??
          int.tryParse(element['duration']?.toString() ?? '') ??
          0,
      isStreamable:
          (element['is_streamable'] ?? element['isStreamable'])?.toString() ??
          '',
      artwork: element['artwork']?.toString(),
      streamUrl: element['streamUrl']?.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<TrackProvider>();

    final recent = tracker.recentSongs();
    final mostPlayed = tracker.mostPlayedSong();

    // Switch between personalised and most-played songs
    final bool showMostPlayed = mostPlayed.length >= 7;

    // Convert both lists into TrackModel objects
    final List<TrackModel> displayedSongs = showMostPlayed
        ? mostPlayed.map((song) => trackFromMap(song)).toList()
        : tracker.homeSongsList;

    final justBackIn = recent.length > 1
        ? recent.skip(1).take(5).toList()
        : <Map>[];

    final trendingSongs = tracker.trendingSongs();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP FILTERS
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Text("M"),
                    ),

                    const SizedBox(width: 12),

                    _filterChip("All"),
                    const SizedBox(width: 10),

                    _filterChip("Music"),
                    const SizedBox(width: 10),

                    _filterChip("Podcasts"),
                  ],
                ),

                const SizedBox(height: 10),

                // HOME SONG GRID
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),

                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 3.37,
                        ),

                    itemCount: displayedSongs.length + 1,

                    itemBuilder: (context, index) {
                      // LIKED SONGS TILE
                      if (index == displayedSongs.length) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
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
                            );
                          },

                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(81, 116, 114, 114),
                              borderRadius: BorderRadius.circular(5),
                            ),

                            child: Row(
                              children: [
                                Container(
                                  height: 55,
                                  width: 50,

                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Colors.deepPurple, Colors.white],
                                    ),

                                    borderRadius: BorderRadius.circular(5),
                                  ),

                                  child: const Center(
                                    child: Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 8),

                                const Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: Text(
                                    "Liked Songs",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // SONG DATA
                      final TrackModel song = displayedSongs[index];

                      return GestureDetector(
                        onTap: () {
                          log(
                            showMostPlayed
                                ? "Most played song pressed"
                                : "Personalised song pressed",
                          );

                          context.read<TrackProvider>().setSongAndPlay(song);
                        },

                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(81, 116, 114, 114),
                            borderRadius: BorderRadius.circular(4),
                          ),

                          child: Row(
                            children: [
                              // SONG IMAGE
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),

                                child: CachedNetworkImage(
                                  imageUrl: song.artwork ?? '',
                                  fit: BoxFit.cover,
                                  height: 51,
                                  width: 51,

                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: const Color.fromARGB(
                                          225,
                                          160,
                                          160,
                                          160,
                                        ),

                                        child: const Center(
                                          child: Icon(
                                            Icons.music_note,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              // SONG TITLE
                              Expanded(
                                child: Text(
                                  song.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // JUST BACK IN
                if (justBackIn.length > 2) ...[
                  const Text(
                    "Just back in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 3.8,

                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: justBackIn.length,

                      itemBuilder: (context, index) {
                        final element = justBackIn[index];
                        final song = trackFromMap(element);

                        return Padding(
                          padding: const EdgeInsets.only(right: 15, top: 6),

                          child: GestureDetector(
                            onTap: () {
                              context.read<TrackProvider>().setSongAndPlay(
                                song,
                              );
                            },

                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                              ),

                              height: MediaQuery.sizeOf(context).height / 3.8,

                              width: MediaQuery.sizeOf(context).width / 2.5,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),

                                    child: Container(
                                      color: const Color.fromARGB(
                                        225,
                                        160,
                                        160,
                                        160,
                                      ),

                                      height: 150,
                                      width: double.infinity,

                                      child: CachedNetworkImage(
                                        imageUrl: song.artwork ?? '',
                                        fit: BoxFit.cover,

                                        errorWidget: (context, url, error) =>
                                            const Center(
                                              child: Icon(
                                                Icons.music_note,
                                                color: Colors.white,
                                                size: 44,
                                              ),
                                            ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  const Text(
                                    "Song",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  Text(
                                    song.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,

                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 30),

                // RECOMMENDED FOR TODAY
                const Text(
                  "Recommended for today",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 2),

                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 3.8,

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: trendingSongs.length,

                    itemBuilder: (context, index) {
                      final TrackModel element = trendingSongs[index];

                      return Padding(
                        padding: const EdgeInsets.only(right: 15, top: 6),

                        child: GestureDetector(
                          onTap: () {
                            context.read<TrackProvider>().setSongAndPlay(
                              element,
                            );
                          },

                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent,
                            ),

                            height: MediaQuery.sizeOf(context).height / 3.8,

                            width: MediaQuery.sizeOf(context).width / 2.5,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),

                                  child: Container(
                                    color: const Color.fromARGB(
                                      225,
                                      160,
                                      160,
                                      160,
                                    ),

                                    height: 150,
                                    width: double.infinity,

                                    child: CachedNetworkImage(
                                      imageUrl: element.artwork ?? '',
                                      fit: BoxFit.cover,

                                      errorWidget: (context, url, error) =>
                                          const Center(
                                            child: Icon(
                                              Icons.music_note,
                                              color: Colors.white,
                                              size: 44,
                                            ),
                                          ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  "Song",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                Text(
                                  element.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 100),

                const Text("Hello", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TOP FILTER CHIP
  Widget _filterChip(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(16),
      ),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),

      child: Center(
        child: Text(title, style: const TextStyle(color: Colors.black)),
      ),
    );
  }
}
