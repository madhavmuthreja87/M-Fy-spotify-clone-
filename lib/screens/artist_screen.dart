import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sf/models/track_model.dart';
import 'package:sf/providers/track_provider.dart';
import 'package:sf/services/youtube_services.dart';

class ArtistScreen extends StatefulWidget {
  final String artistname;
  const ArtistScreen({super.key, required this.artistname});

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  List<TrackModel> searchResult = [];
  bool hasSearched = false;
  bool isSearching = false;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchYoutube(widget.artistname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      backgroundColor: const Color(0xFF121212),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.333,
                  width: double.infinity,
                  color: Colors.green,
                ),
                Positioned(
                  top: 35,
                  left: 13,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, size: 24, color: Colors.white),
                  ),
                ),
                Positioned(
                  top: 35,
                  right: 13,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert_rounded,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 19,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.artistname,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.verified,
                            size: 20,
                            color: const Color.fromARGB(255, 90, 201, 93),
                          ),
                          SizedBox(width: 3),
                          Text(
                            "Verified by M-Fy",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      "8M monthly listeners",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.read_more),
                            SizedBox(width: 6),
                            OutlinedButton(
                              onPressed: () {},
                              child: Text(
                                "Following",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Icon(Icons.shuffle, color: Colors.green, size: 40),
                            SizedBox(width: 8),
                            Icon(
                              Icons.play_circle,
                              color: Colors.green,
                              size: 44,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromARGB(255, 54, 53, 53),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.new_label),
                              SizedBox(width: 7),
                              Text(
                                "Listen to new track",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),

                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 19),
                    Text(
                      "Popular",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemCount: searchResult.length,
              itemBuilder: (context, index) {
                final searchContent = searchResult[index];
                // final dur = _fmt(searchContent.duration);

                return GestureDetector(
                  onTap: () {
                    log("music list tapped");
                    FocusScope.of(context).unfocus();
                    context.read<TrackProvider>().setSongAndPlay(searchContent);
                  },

                  ////////////////////////////
                  child: Slidable(
                    key: ValueKey(searchContent.id),
                    startActionPane: ActionPane(
                      motion: const StretchMotion(), // the stretch effect
                      extentRatio: 0.25,
                      dismissible: DismissiblePane(
                        closeOnCancel: true, // row slides back after release
                        dismissThreshold:
                            0.20, // how far to swipe to trigger (0 to 1)
                        onDismissed: () {}, // never called, because we return false below
                        confirmDismiss: () async {
                          final player = context.read<TrackProvider>();

                          player.addToQueue(searchContent);

                          log("Song Added to Queue");
                          log('Current Queue length: ${player.queue.length}');

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  "Added to queue",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );

                          FocusScope.of(context).unfocus();

                          return false;
                        },
                      ),
                      children: [
                        SlidableAction(
                          onPressed: (actionContext) {
                            actionContext.read<TrackProvider>().addToQueue(
                              searchContent,
                            );

                            Slidable.of(actionContext)?.close();

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text("Added to queue"),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                          },
                          backgroundColor: const Color(0xFF1DB954),
                          foregroundColor: Colors.white,
                          icon: Icons.queue_music,
                        ),
                      ],
                    ),
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
                              child: Icon(
                                Icons.music_note,
                                color: Colors.white,
                              ),
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
                        "${searchContent.artist}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 167),
          ],
        ),
      ),
    );
  }
}
