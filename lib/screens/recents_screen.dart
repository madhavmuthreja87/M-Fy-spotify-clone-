// import 'dart:developer';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sf/services/audis_api.dart';

// import 'package:sf/providers/track_provider.dart';
// import 'package:sf/models/track_model.dart';
// import 'package:sf/services/youtube_services.dart';

// class RecentsScreen extends StatefulWidget {
//   const RecentsScreen({super.key});

//   @override
//   State<RecentsScreen> createState() => _RecentsScreenState();
// }

// class _RecentsScreenState extends State<RecentsScreen> {
//   TextEditingController searchController = TextEditingController();
//   List<TrackModel> searchResult = [];
//   List<TrackModel> recentResult = [];

//   bool isSearching = false;

//   Future<void> searchSongs(String query) async {
//     if (query.trim().isEmpty) {
//       return;
//     }

//     setState(() {
//       isSearching = true;
//     });

//     try {
//       final results = await AudisApi().searchTracks(query);

//       // final streamableResults = results
//       //     .where((song) => song.isStreamable)
//       //     .toList();

//       setState(() {
//         isSearching = false;
//         searchResult = results;
//       });

//       for (var i in searchResult) {
//         print("Title: ${i.title}");
//         print("isStreamable: ${i.isStreamable}");
//         print("Artist: ${i.artist}");
//         print("ID: ${i.id}");
//         print("-------------");
//       }
//     } catch (e) {
//       setState(() {
//         isSearching = false;
//       });
//       print(e);
//     }
//   }

//   Future<void> searchSongsFromYoutube(String query) async {
//     final yt = YoutubeServices();

//     try {
//       final videos = await yt.searchFromYoutube(query);

//       log("========== YouTube Search Details ==========");
//       log("Total videos found: ${videos.length}");

//       for (var i = 0; i < videos.length; i++) {
//         final video = videos[i];

//         print("\n========== Video ${i + 1} ==========");
//         print("Video ID: ${video.id}");
//         print("Title: ${video.title}");
//         print("Author / Channel: ${video.author}");
//         print("Video URL: ${video.url}");
//         print("Duration: ${video.duration}");
//         print("Description: ${video.description}");
//         print("Channel ID: ${video.channelId}");
//         print("Upload Date: ${video.uploadDate}");
//         print("Publish Date: ${video.publishDate}");
//         print("Is Live: ${video.isLive}");
//         print("Keywords: ${video.keywords}");
//         print("Music Data: ${video.musicData}");
//         print("Views: ${video.engagement.viewCount}");
//         print("Likes: ${video.engagement.likeCount}");
//         print("Thumbnail: ${video.thumbnails.highResUrl}");

//         // Extract and print audio URL with the video information.
//         try {
//           final audioUrl = await yt.getAudioUrl(video.id.toString());
//           print("Audio URL: $audioUrl");
//         } catch (e) {
//           print("Audio URL extraction failed: $e");
//         }

//         print("============================================");
//       }
//     } catch (e, stackTrace) {
//       log("YouTube search failed: $e");
//       log("$stackTrace");
//     } finally {
//       yt.dispose();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final player = context.watch<TrackProvider>();
//     return Scaffold(
//       backgroundColor: const Color(0xFF121212),
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         titleSpacing: 0,
//         backgroundColor: const Color.fromARGB(36, 247, 247, 247),
//         title: Padding(
//           padding: const EdgeInsets.only(right: 18.0),
//           child: SizedBox(
//             width: MediaQuery.sizeOf(context).width,
//             height: 34,
//             child: TextField(
//               controller: searchController,
//               cursorColor: Colors.green,
//               autofocus: true,
//               selectionControls: EmptyTextSelectionControls(),
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 17,
//                 fontWeight: FontWeight.w500,
//               ),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide.none,
//                   borderRadius: BorderRadius.circular(30),
//                 ),

//                 filled: true,
//                 hint: Text(
//                   "What do you want to listen to?",
//                   style: TextStyle(
//                     fontSize: 15,
//                     color: const Color.fromARGB(176, 224, 224, 224),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 fillColor: const Color.fromARGB(108, 106, 105, 105),
//               ),
//               onSubmitted: (value) {
//                 // if (value.isEmpty) {
//                 //   setState(() {
//                 //     searchResult = [];
//                 //   });
//                 //   return;
//                 // }

//                 searchSongs(value);
//                 searchSongsFromYoutube(value);
//               },
//             ),
//           ),
//         ),
//       ),

//       body: SafeArea(
//         child: searchResult.isNotEmpty
//             ? ListView.builder(
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: searchResult.length,
//                 itemBuilder: (context, index) {
//                   final searchContent = searchResult[index];

//                   return GestureDetector(
//                     onTap: () {
//                       log("music list tapped");
//                       context.read<TrackProvider>().setSongAndPlay(
//                         searchContent,
//                       );
//                     },
//                     child: ListTile(
//                       //   contentPadding: EdgeInsets.zero,
//                       dense: true,

//                       leading: ClipRRect(
//                         borderRadius: BorderRadius.circular(7),
//                         // child: Image.network(
//                         //   searchContent.artwork!,
//                         //   fit: BoxFit.cover,
//                         //   height: 50,
//                         //   width: 50,
//                         // ),
//                         child: CachedNetworkImage(
//                           imageUrl: searchContent.artwork!,
//                           fit: BoxFit.cover,
//                           height: 50,
//                           width: 50,
//                           errorWidget: (context, url, error) => Container(
//                             color: const Color.fromARGB(225, 160, 160, 160),
//                             child: const Center(
//                               child: Icon(
//                                 Icons.music_note,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       title: Text(
//                         searchContent.title,
//                         maxLines: 1,

//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       subtitle: Text(
//                         searchContent.artist,
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ),
//                   );
//                 },
//               )
//             : Consumer<TrackProvider>(
//                 builder: (context, player, child) {
//                   final recentSongs = player.recentSongs();
//                   final likedSongs = player.likedSongs();

//                   return recentSongs.length != 0
//                       ? Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16.0,
//                             vertical: 7,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   log("Recent songs :${recentResult.length}");
//                                   for (TrackModel i in recentResult) {
//                                     log(i.title);
//                                     log(i.id);
//                                     log("----------");
//                                   }
//                                 },
//                                 child: Text(
//                                   "Recents",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: ListView.builder(
//                                   shrinkWrap: true,
//                                   itemCount: recentSongs.length + 1,
//                                   itemBuilder: (context, index) {
//                                     if (index == recentSongs.length) {
//                                       return Column(
//                                         children: [
//                                           const SizedBox(height: 25),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   showAdaptiveDialog(
//                                                     context: context,
//                                                     builder: (context) {
//                                                       return AlertDialog.adaptive(
//                                                         backgroundColor:
//                                                             const Color(
//                                                               0xFF121212,
//                                                             ),
//                                                         shape: RoundedRectangleBorder(
//                                                           borderRadius:
//                                                               BorderRadiusGeometry.circular(
//                                                                 8,
//                                                               ),
//                                                         ),
//                                                         content: Text(
//                                                           "Are you sure want to clear your recent searches?",
//                                                           style: TextStyle(
//                                                             color: Colors.white,
//                                                             fontSize: 16,
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                           ),
//                                                         ),
//                                                         actions: [
//                                                           TextButton(
//                                                             onPressed: () {
//                                                               Navigator.pop(
//                                                                 context,
//                                                               );
//                                                             },
//                                                             child: Text(
//                                                               "CANCEL",
//                                                               style: TextStyle(
//                                                                 color: Colors
//                                                                     .green,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           TextButton(
//                                                             onPressed: () async {
//                                                               await player
//                                                                   .removeAllrecentSong();
//                                                               Navigator.pop(
//                                                                 context,
//                                                               );
//                                                             },
//                                                             child: Text(
//                                                               "CLEAR",
//                                                               style: TextStyle(
//                                                                 color: Colors
//                                                                     .green,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       );
//                                                     },
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   padding:
//                                                       const EdgeInsets.symmetric(
//                                                         horizontal: 7,
//                                                         vertical: 7,
//                                                       ),
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           20,
//                                                         ),
//                                                     border: Border.all(
//                                                       color: Colors.grey,
//                                                     ),
//                                                   ),
//                                                   child: const Text(
//                                                     "Clear recent searches",
//                                                     maxLines: 1,
//                                                     style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 13,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 30),
//                                         ],
//                                       );
//                                     }
//                                     final recentContent = recentSongs[index];
//                                     bool isLiked = likedSongs.any(
//                                       (song) =>
//                                           song['id'] == recentContent['id'],
//                                     );
//                                     TrackModel currentTrack = TrackModel(
//                                       id: recentContent['id'] ?? "",
//                                       title: recentContent['title'] ?? "",
//                                       artist: recentContent['artist'] ?? "",
//                                       duration: recentContent['duration'] ?? "",
//                                       isStreamable:
//                                           recentContent['isStreamable'] ?? "",
//                                       artwork: recentContent['artwork'] ?? "",
//                                       streamUrl:
//                                           recentContent['streamUrl'] ?? "",
//                                     );
//                                     return GestureDetector(
//                                       onTap: () {
//                                         player.setSongAndPlay(
//                                           TrackModel(
//                                             id: recentContent['id'] ?? "",
//                                             title: recentContent['title'] ?? "",
//                                             artist:
//                                                 recentContent['artist'] ?? "",
//                                             duration:
//                                                 recentContent['duration'] ?? "",
//                                             isStreamable:
//                                                 recentContent['isStreamable'] ??
//                                                 "",
//                                             artwork:
//                                                 recentContent['artwork'] ?? "",
//                                             streamUrl:
//                                                 recentContent['streamUrl'] ??
//                                                 "",
//                                           ),
//                                         );
//                                       },
//                                       child: ListTile(
//                                         contentPadding: EdgeInsets.zero,
//                                         dense: true,
//                                         leading: ClipRRect(
//                                           borderRadius: BorderRadius.circular(
//                                             7,
//                                           ),
//                                           // child: Image.network(
//                                           //   recentContent['artwork'],
//                                           //   fit: BoxFit.cover,
//                                           //   height: 47,
//                                           //   width: 47,
//                                           // ),
//                                           child: CachedNetworkImage(
//                                             imageUrl: recentContent['artwork'],
//                                             fit: BoxFit.cover,
//                                             height: 47,
//                                             width: 47,
//                                             errorWidget:
//                                                 (context, url, error) =>
//                                                     Container(
//                                                       color:
//                                                           const Color.fromARGB(
//                                                             225,
//                                                             160,
//                                                             160,
//                                                             160,
//                                                           ),
//                                                       child: const Center(
//                                                         child: Icon(
//                                                           Icons.music_note,
//                                                           color: Colors.white,
//                                                         ),
//                                                       ),
//                                                     ),
//                                           ),
//                                         ),
//                                         title: Text(
//                                           recentContent['title'],
//                                           maxLines: 1,

//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                         subtitle: Text(
//                                           recentContent['artist'],
//                                           style: TextStyle(color: Colors.grey),
//                                         ),
//                                         trailing: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             const SizedBox(width: 8),
//                                             GestureDetector(
//                                               onTap: () async {
//                                                 log("Like the song pressed");

//                                                 if (!isLiked)
//                                                   await player.saveLikedSongs(
//                                                     currentTrack,
//                                                   );
//                                                 else
//                                                   await player.removeLikedSong(
//                                                     currentTrack.id,
//                                                   );

//                                                 setState(() {});

//                                                 log(
//                                                   likedSongs.length.toString(),
//                                                 );
//                                               },
//                                               child: !isLiked
//                                                   ? Icon(
//                                                       Icons.add_circle_outline,
//                                                       color: Colors.grey,
//                                                       size: 20,
//                                                     )
//                                                   : Icon(
//                                                       Icons.check_circle,
//                                                       color:
//                                                           const Color.fromARGB(
//                                                             255,
//                                                             92,
//                                                             214,
//                                                             96,
//                                                           ),
//                                                       size: 20,
//                                                     ),
//                                             ),
//                                             const SizedBox(width: 25),
//                                             GestureDetector(
//                                               onTap: () {
//                                                 player.removeRecentSong(
//                                                   currentTrack.id,
//                                                 );
//                                               },
//                                               child: Icon(
//                                                 Icons.close,
//                                                 color: Colors.grey,
//                                                 size: 26,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : Padding(
//                           padding: const EdgeInsets.all(18.0),
//                           child: Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Play what you love",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 21,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 Text(
//                                   "Search for artists, songs, playlists, podcasts and more.",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 15.5,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                 },
//               ),
//       ),
//     );
//   }
// }
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sf/services/audis_api.dart';

import 'package:sf/providers/track_provider.dart';
import 'package:sf/models/track_model.dart';
import 'package:sf/services/youtube_services.dart';

class RecentsScreen extends StatefulWidget {
  const RecentsScreen({super.key});

  @override
  State<RecentsScreen> createState() => _RecentsScreenState();
}

class _RecentsScreenState extends State<RecentsScreen> {
  TextEditingController searchController = TextEditingController();
  List<TrackModel> searchResult = [];

  bool isSearching = false;
  bool hasSearched = false; // true after the first submitted search

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Search YouTube and turn each Video into a TrackModel.
  // Only metadata is stored here. The audio URL is fetched when the song is
  // played, because YouTube stream URLs expire after a few hours.
  Future<void> searchYoutube(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        searchResult = [];
        hasSearched = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
      hasSearched = true;
    });

    final yt = YoutubeServices();

    try {
      final videos = await yt.searchFromYoutube(query);

      final tracks = videos.map((v) {
        return TrackModel(
          id: v.id.value, // YouTube video id (used to get the audio later)
          title: v.title,
          artist: v.author,
          duration: v.duration?.inSeconds ?? 0,
          isStreamable: 'true',
          artwork: v.thumbnails.maxResUrl,
          streamUrl: '', // filled in at play time
        );
      }).toList();

      if (!mounted) return;
      setState(() {
        searchResult = tracks;
        isSearching = false;
      });
    } catch (e, st) {
      log("YouTube search failed: $e");
      log("$st");
      if (!mounted) return;
      setState(() {
        searchResult = [];
        isSearching = false;
      });
    } finally {
      yt.dispose();
    }
  }

  String _fmt(dynamic seconds) {
    final s = int.tryParse(seconds.toString()) ?? 0;
    if (s <= 0) return '';
    final m = s ~/ 60;
    final r = (s % 60).toString().padLeft(2, '0');
    return '$m:$r';
  }

  Widget _searchBody() {
    if (isSearching) {
      return Positioned.fill(
        child: IgnorePointer(
          child: const Center(
            child: SizedBox(
              height: 37.5,
              width: 37.5,
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 65, 197, 69),
                backgroundColor: Color.fromARGB(174, 87, 201, 91),
                strokeWidth: 6,
              ),
            ),
          ),
        ),
      );
    }

    if (searchResult.isEmpty) {
      return const Center(
        child: Text(
          "No results found",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: searchResult.length,
      itemBuilder: (context, index) {
        final searchContent = searchResult[index];
        final dur = _fmt(searchContent.duration);

        return GestureDetector(
          onTap: () {
            log("music list tapped");
            FocusScope.of(context).unfocus();
            context.read<TrackProvider>().setSongAndPlay(searchContent);
          },
          child: ListTile(
            dense: true,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: CachedNetworkImage(
                imageUrl: searchContent.artwork ?? '',
                fit: BoxFit.cover,
                height: 50,
                width: 50,
                errorWidget: (context, url, error) => Container(
                  color: const Color.fromARGB(225, 160, 160, 160),
                  child: const Center(
                    child: Icon(Icons.music_note, color: Colors.white),
                  ),
                ),
              ),
            ),
            title: Text(
              searchContent.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.7,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              dur.isEmpty
                  ? searchContent.artist
                  : "${searchContent.artist} • $dur",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0,
        backgroundColor: const Color.fromARGB(36, 247, 247, 247),
        title: Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 34,
            child: TextField(
              controller: searchController,
              cursorColor: Colors.green,
              autofocus: true,
              textInputAction: TextInputAction.search,
              selectionControls: EmptyTextSelectionControls(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,

                hint: Text(
                  "What do you want to listen to?",
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color.fromARGB(176, 224, 224, 224),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                fillColor: const Color.fromARGB(108, 106, 105, 105),
              ),
              // Clearing the box brings the Recents list back.
              onChanged: (value) {
                searchYoutube(value);
                if (value.trim().isEmpty &&
                    (hasSearched || searchResult.isNotEmpty)) {
                  setState(() {
                    searchResult = [];
                    hasSearched = false;
                    isSearching = false;
                  });
                }
              },
              onSubmitted: (value) {
                searchYoutube(value);
              },
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: (hasSearched || isSearching)
            ? _searchBody()
            : Consumer<TrackProvider>(
                builder: (context, player, child) {
                  final recentSongs = player.recentSongs();
                  final likedSongs = player.likedSongs();

                  return recentSongs.length != 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 7,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Recents",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: recentSongs.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == recentSongs.length) {
                                      return Column(
                                        children: [
                                          const SizedBox(height: 25),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  showAdaptiveDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog.adaptive(
                                                        backgroundColor:
                                                            const Color(
                                                              0xFF121212,
                                                            ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        content: Text(
                                                          "Are you sure want to clear your recent searches?",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: Text(
                                                              "CANCEL",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () async {
                                                              await player
                                                                  .removeAllrecentSong();
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: Text(
                                                              "CLEAR",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 7,
                                                        vertical: 7,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    "Clear recent searches",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 30),
                                        ],
                                      );
                                    }
                                    final recentContent = recentSongs[index];
                                    bool isLiked = likedSongs.any(
                                      (song) =>
                                          song['id'] == recentContent['id'],
                                    );
                                    TrackModel currentTrack = TrackModel(
                                      id: recentContent['id'] ?? "",
                                      title: recentContent['title'] ?? "",
                                      artist: recentContent['artist'] ?? "",
                                      duration: recentContent['duration'] ?? "",
                                      isStreamable:
                                          recentContent['isStreamable'] ?? "",
                                      artwork: recentContent['artwork'] ?? "",
                                      streamUrl:
                                          recentContent['streamUrl'] ?? "",
                                    );
                                    return GestureDetector(
                                      onTap: () {
                                        player.setSongAndPlay(currentTrack);
                                      },
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            7,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: recentContent['artwork'],
                                            fit: BoxFit.cover,
                                            height: 47,
                                            width: 47,
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      color:
                                                          const Color.fromARGB(
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
                                        title: Text(
                                          recentContent['title'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.7,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          recentContent['artist'],
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () async {
                                                log("Like the song pressed");

                                                if (!isLiked)
                                                  await player.saveLikedSongs(
                                                    currentTrack,
                                                  );
                                                else
                                                  await player.removeLikedSong(
                                                    currentTrack.id,
                                                  );

                                                setState(() {});
                                              },
                                              child: !isLiked
                                                  ? Icon(
                                                      Icons.add_circle_outline,
                                                      color: Colors.grey,
                                                      size: 20,
                                                    )
                                                  : Icon(
                                                      Icons.check_circle,
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            92,
                                                            214,
                                                            96,
                                                          ),
                                                      size: 20,
                                                    ),
                                            ),
                                            const SizedBox(width: 25),
                                            GestureDetector(
                                              onTap: () {
                                                player.removeRecentSong(
                                                  currentTrack.id,
                                                );
                                              },
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.grey,
                                                size: 26,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Play what you love",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Search for artists, songs, playlists, podcasts and more.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                },
              ),
      ),
    );
  }
}
