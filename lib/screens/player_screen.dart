import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:palette_generator_plus/palette_generator_plus.dart';
import 'package:provider/provider.dart';
import 'package:sf/providers/track_provider.dart';
import 'package:sf/models/track_model.dart';

class PlayerScreen extends StatefulWidget {
  final TrackModel song;

  // final VoidCallback onPlayPause;

  const PlayerScreen({super.key, required this.song});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  String FormatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  Color backgroundColor = Colors.black;

  Future<void> getBackgroundColor() async {
    final palette = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.song.artwork!),
    );
    Color selectedColor = Colors.blueGrey;

    final colors = palette.colors.toList();

    for (final color in colors) {
      final lightness = HSLColor.fromColor(color).lightness;

      if (lightness > 0.25) {
        selectedColor = color;
        break;
      }
    }

    setState(() {
      backgroundColor = selectedColor;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBackgroundColor();
  }

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<TrackProvider>();
    final player = tracker.player;
    bool isLiked = tracker.likedSongs().any(
      (song) => song['id'] == widget.song.id,
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,

      appBar: AppBar(
        iconTheme: IconThemeData(
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        titleSpacing: 0,
        backgroundColor: Colors.transparent,

        centerTitle: true,
        title: Text(
          "Recommended for you",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [backgroundColor, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Card(
                    elevation: 22,
                    shadowColor: Colors.black,
                    borderOnForeground: true,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      // child: Image.network(
                      //   widget.song.artwork!,
                      //   fit: BoxFit.cover,
                      //   height: 320,
                      //   width: 340,
                      // ),
                      child: CachedNetworkImage(
                        imageUrl: widget.song.artwork!,
                        fit: BoxFit.cover,
                        height: 320,
                        width: 340,
                        errorWidget: (context, url, error) => Container(
                          color: const Color.fromARGB(225, 160, 160, 160),
                          child: const Center(
                            child: Icon(
                              Icons.music_note,
                              size: 110,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.song.title.length > 13
                                ? widget.song.title.substring(0, 13) + "..."
                                : widget.song.title,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                color: const Color.fromARGB(255, 94, 209, 98),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Not set",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(width: 10),

                          GestureDetector(
                            onTap: () async {
                              log("Like the song pressed");

                              if (!isLiked)
                                await tracker.saveLikedSongs(widget.song);
                              else
                                await tracker.removeLikedSong(widget.song.id);

                              setState(() {});

                              log(tracker.likedSongs().length.toString());
                            },
                            child: isLiked
                                ? Lottie.asset(
                                    'assets/animations/Done.json',

                                    width: 50,
                                    height: 50,
                                    repeat: false,
                                  )
                                : const Icon(
                                    Icons.add_circle_outline_rounded,
                                    color: Colors.white,
                                    size: 37,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 23),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: StreamBuilder<Duration>(
                          stream: player.positionStream,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            final duration = player.duration ?? Duration.zero;
                            return Column(
                              children: [
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                    trackShape:
                                        const RoundedRectSliderTrackShape(),
                                    thumbColor: Colors.white,
                                    inactiveTrackColor: Colors.grey,
                                    activeTrackColor: Colors.white,
                                    trackHeight: 1.5,

                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 5,
                                    ),
                                  ),

                                  child: Slider(
                                    min: 0,
                                    max: duration.inSeconds.toDouble(),
                                    value: position.inSeconds.toDouble().clamp(
                                      0,
                                      duration.inSeconds.toDouble(),
                                    ),
                                    onChanged: (value) {
                                      player.seek(
                                        Duration(seconds: value.toInt()),
                                      );
                                    },
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7.0,
                                    vertical: 1,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        FormatDuration(position),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        FormatDuration(duration),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.shuffle_rounded,
                        size: 28,
                        color: Colors.white,
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.skip_previous_rounded,
                            size: 45,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),

                          GestureDetector(
                            onTap: () {
                              if (tracker.isPlaying) {
                                tracker.pause();
                              } else {
                                tracker.resume();
                              }
                            },
                            child: Icon(
                              tracker.isPlaying
                                  ? Icons.pause_circle_sharp
                                  : Icons.play_circle_sharp,
                              size: 75,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 10),
                          Icon(
                            Icons.skip_next_rounded,
                            size: 45,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Icon(Icons.timer_outlined, size: 28, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
