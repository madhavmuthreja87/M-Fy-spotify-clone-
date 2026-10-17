import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sf/services/audis_api.dart';
import 'package:sf/providers/track_provider.dart';
import 'package:sf/models/track_model.dart';
import 'package:sf/screens/liked_songs.dart';

class HomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrackProvider>().addTemporaryMostPlayedData();
      context.read<TrackProvider>().fetchTrendingSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final tracker = context.watch<TrackProvider>();
    // final secondElement = tracker.recentSongs()[1];
    // final thirdElement = tracker.recentSongs()[2];
    // final fourthElement = tracker.recentSongs()[3];
    // final fifthElement = tracker.recentSongs()[4];
    // final sixthElement = tracker.recentSongs()[5];

    // final mostPlayed0 = tracker.mostPlayedSong()[0];
    // final mostPlayed1 = tracker.mostPlayedSong()[1];
    // final mostPlayed2 = tracker.mostPlayedSong()[2];
    // final mostPlayed3 = tracker.mostPlayedSong()[3];
    // final mostPlayed4 = tracker.mostPlayedSong()[4];
    // final mostPlayed5 = tracker.mostPlayedSong()[5];
    // final mostPlayed6 = tracker.mostPlayedSong()[6];

    // List<Map> justBackIn = [
    //   secondElement,
    //   thirdElement,
    //   fourthElement,
    //   fifthElement,
    //   sixthElement,
    // ];

    // List<Map> mostPlayed = [
    //   mostPlayed0,
    //   mostPlayed1,
    //   mostPlayed2,
    //   mostPlayed3,
    //   mostPlayed4,
    //   mostPlayed5,
    //   mostPlayed6,
    // ];
    final tracker = context.watch<TrackProvider>();

    final recent = tracker.recentSongs();
    final mostPlayed = tracker.mostPlayedSong();

    final justBackIn = recent.length > 1
        ? recent.skip(1).take(5).toList()
        : <Map>[];

    final trendingSongs = tracker.trendingSongs();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6),
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(16),
                        ),

                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        child: Center(
                          child: Text(
                            "All",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        child: Center(
                          child: Text(
                            "Music",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        child: Center(
                          child: Text(
                            "Podcasts",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
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

                      itemCount: tracker.mostPlayedSong().length + 1,

                      itemBuilder: (context, index) {
                        if (index == tracker.mostPlayedSong().length) {
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
                                        colors: [
                                          // Color(0xFF6A45EA),
                                          // Color(0xFF9AA7E3),
                                          Colors.deepPurple,
                                          Colors.white,
                                        ],
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
                        final element = mostPlayed[index];

                        return GestureDetector(
                          onTap: () {
                            log("Most played song section pressed");

                            context.read<TrackProvider>().setSongAndPlay(
                              TrackModel(
                                id: element['id'] ?? "",
                                title: element['title'] ?? "",
                                artist: element['artist'] ?? "",
                                duration: element['duration'] ?? "",
                                isStreamable: element['isStreamable'] ?? "",
                                artwork: element['artwork'] ?? "",
                                streamUrl: element['streamUrl'] ?? "",
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(81, 116, 114, 114),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                // Image
                                ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    5,
                                  ),
                                  // child: Image.network(
                                  //   song['artwork'],
                                  //   width: 51,
                                  //   height: double.infinity,
                                  //   fit: BoxFit.cover,
                                  // ),
                                  child: CachedNetworkImage(
                                    imageUrl: element['artwork'],
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

                                // Song title
                                Expanded(
                                  child: Text(
                                    element['title'],
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

                  justBackIn.length > 2
                      ? Text(
                          "Just back in",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : SizedBox(height: 0),
                  justBackIn.length > 2
                      ? SizedBox(
                          height: MediaQuery.sizeOf(context).height / 3.8,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: justBackIn.length,
                            itemBuilder: (context, index) {
                              Map<dynamic, dynamic> element = justBackIn[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: 15,
                                  top: 6,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<TrackProvider>()
                                        .setSongAndPlay(
                                          TrackModel(
                                            id: element['id'] ?? "",
                                            title: element['title'] ?? "",
                                            artist: element['artist'] ?? "",
                                            duration: element['duration'] ?? "",
                                            isStreamable:
                                                element['isStreamable'] ?? "",
                                            artwork: element['artwork'] ?? "",
                                            streamUrl:
                                                element['streamUrl'] ?? "",
                                          ),
                                        );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.transparent,
                                    ),
                                    height:
                                        MediaQuery.sizeOf(context).height / 3.8,
                                    width:
                                        MediaQuery.sizeOf(context).width / 2.5,

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(8),
                                          // child: Image.network(
                                          //   element['artwork'],
                                          //   fit: BoxFit.cover,
                                          // ),
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
                                              imageUrl: element['artwork'],
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, error) =>
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
                                        Text(
                                          "Song",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          element['title'],
                                          maxLines: 1,
                                          style: TextStyle(
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
                        )
                      : SizedBox(height: 0),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     spacing: 13,
                  //     children: [
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           color: Colors.blue,
                  //         ),
                  //         height: MediaQuery.sizeOf(context).height / 3.8,
                  //         width: MediaQuery.sizeOf(context).width / 2.5,

                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Container(
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 color: Colors.green,
                  //               ),
                  //               height: MediaQuery.sizeOf(context).height / 5,
                  //               width: MediaQuery.sizeOf(context).width / 2.5,

                  //               child: Text("Image"),
                  //             ),
                  //             Text("Name of song"),
                  //           ],
                  //         ),
                  //       ),
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           color: Colors.blue,
                  //         ),
                  //         height: MediaQuery.sizeOf(context).height / 3.8,
                  //         width: MediaQuery.sizeOf(context).width / 2.5,

                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Container(
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 color: Colors.green,
                  //               ),
                  //               height: MediaQuery.sizeOf(context).height / 5,
                  //               width: MediaQuery.sizeOf(context).width / 2.5,

                  //               child: Text("Image"),
                  //             ),
                  //             Text("Name of song"),
                  //           ],
                  //         ),
                  //       ),
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           color: Colors.blue,
                  //         ),
                  //         height: MediaQuery.sizeOf(context).height / 3.8,
                  //         width: MediaQuery.sizeOf(context).width / 2.5,

                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Container(
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 color: Colors.green,
                  //               ),
                  //               height: MediaQuery.sizeOf(context).height / 5,
                  //               width: MediaQuery.sizeOf(context).width / 2.5,

                  //               child: Text("Image"),
                  //             ),
                  //             Text("Name of song"),
                  //           ],
                  //         ),
                  //       ),
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           color: Colors.blue,
                  //         ),
                  //         height: MediaQuery.sizeOf(context).height / 3.8,
                  //         width: MediaQuery.sizeOf(context).width / 2.5,

                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Container(
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 color: Colors.green,
                  //               ),
                  //               height: MediaQuery.sizeOf(context).height / 5,
                  //               width: MediaQuery.sizeOf(context).width / 2.5,

                  //               child: Text("Image"),
                  //             ),
                  //             Text("Name of song"),
                  //           ],
                  //         ),
                  //       ),
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           color: Colors.blue,
                  //         ),
                  //         height: MediaQuery.sizeOf(context).height / 3.8,
                  //         width: MediaQuery.sizeOf(context).width / 2.5,

                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Container(
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 color: Colors.green,
                  //               ),
                  //               height: MediaQuery.sizeOf(context).height / 5,
                  //               width: MediaQuery.sizeOf(context).width / 2.5,

                  //               child: Text("Image"),
                  //             ),
                  //             Text("Name of song"),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 30),
                  Text(
                    "Recommended for today",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),

                  //Yaha se saare provider me dalke fir fetch krvwaana hai
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 3.8,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: trendingSongs.length,
                      itemBuilder: (context, index) {
                        final element = trendingSongs[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 15, top: 6),
                          child: GestureDetector(
                            onTap: () {
                              context.read<TrackProvider>().setSongAndPlay(
                                element,
                                // TrackModel(
                                //   id: element['id'] ?? "",
                                //   title: element['title'] ?? "",
                                //   artist: element['artist'] ?? "",
                                //   duration: element['duration'] ?? "",
                                //   isStreamable: element['isStreamable'] ?? "",
                                //   artwork: element['artwork'] ?? "",
                                //   streamUrl: element['streamUrl'] ?? "",
                                // ),
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
                                    borderRadius: BorderRadiusGeometry.circular(
                                      8,
                                    ),
                                    // child: Image.network(
                                    //   element['artwork'],
                                    //   fit: BoxFit.cover,
                                    // ),
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
                                        imageUrl: element.artwork!,
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
                                  Text(
                                    "Song",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    element.title,
                                    maxLines: 1,
                                    style: TextStyle(
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
                  // FutureBuilder<List<TrackModel>>(
                  //   future: AudisApi().getTrendingTracks(),

                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return const CircularProgressIndicator();
                  //     }

                  //     if (snapshot.hasError) {
                  //       return Text(
                  //         "Error: ${snapshot.error}",
                  //         style: const TextStyle(color: Colors.white),
                  //       );
                  //     }

                  //     final songs = snapshot.data!;

                  //     return SizedBox(
                  //       height: MediaQuery.sizeOf(context).height / 3.5,

                  //       child: ListView.builder(
                  //         scrollDirection: Axis.horizontal,
                  //         itemCount: songs.length,
                  //         itemBuilder: (context, index) {
                  //           final song = songs[index];

                  //           return Container(
                  //             height: MediaQuery.sizeOf(context).height / 3.8,
                  //             width: MediaQuery.sizeOf(context).width / 2.5,

                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(10),
                  //             ),
                  //             padding: EdgeInsets.only(right: 10),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 ClipRRect(
                  //                   borderRadius: BorderRadius.circular(10),
                  //                   // child: Image.network(
                  //                   //   song.artwork ?? "",
                  //                   //   fit: BoxFit.cover,
                  //                   //   height: 160,
                  //                   //   width: 150,
                  //                   // ),
                  //                   child: CachedNetworkImage(
                  //                     imageUrl: song.artwork ?? "",
                  //                     fit: BoxFit.cover,
                  //                   ),
                  //                 ),
                  //                 const SizedBox(height: 8),
                  //                 Text(
                  //                   song.title,
                  //                   maxLines: 1,
                  //                   overflow: TextOverflow.ellipsis,
                  //                   style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.w600,
                  //                   ),
                  //                 ),
                  //                 Text(
                  //                   song.artist,
                  //                   maxLines: 1,
                  //                   overflow: TextOverflow.ellipsis,
                  //                   style: TextStyle(color: Colors.white),
                  //                 ),
                  //               ],
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     );
                  //   },
                  // ),
                  const SizedBox(height: 100),
                  Text("Hello", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
