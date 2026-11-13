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

  const PlayerScreen({super.key, required this.song});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  String FormatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  Color backgroundColor = Colors.black;

  late TrackProvider _tracker;
  String? _lastSongId;

  @override
  void initState() {
    super.initState();

    _tracker = context.read<TrackProvider>();

    // Get the currently playing song.
    final initialSong = _tracker.currentSong ?? widget.song;

    _lastSongId = initialSong.id;

    // Listen for queue song changes.
    _tracker.addListener(_onTrackChanged);

    // Extract initial song color.
    getBackgroundColor(initialSong.artwork, initialSong.id);
  }

  // Called whenever TrackProvider notifies listeners.
  void _onTrackChanged() {
    final currentSong = _tracker.currentSong;

    if (currentSong == null) return;

    // Only extract color when the song actually changes.
    if (currentSong.id == _lastSongId) return;

    _lastSongId = currentSong.id;

    getBackgroundColor(currentSong.artwork, currentSong.id);
  }

  // Extract artwork color safely.
  Future<void> getBackgroundColor(String? artwork, String songId) async {
    if (artwork == null || artwork.isEmpty) {
      if (!mounted || _lastSongId != songId) return;

      setState(() {
        backgroundColor = const Color(0xFF191414);
      });
      return;
    }

    try {
      final palette = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(artwork),
        maximumColorCount: 8,
      );

      final selectedColor =
          palette.vibrantColor?.color ??
          palette.darkVibrantColor?.color ??
          palette.mutedColor?.color ??
          palette.dominantColor?.color ??
          const Color(0xFF191414);

      // Ignore results belonging to an older song.
      if (!mounted || _lastSongId != songId) return;

      setState(() {
        backgroundColor = selectedColor;
      });
    } catch (e) {
      if (!mounted || _lastSongId != songId) return;

      log("Palette extraction error: $e");

      setState(() {
        backgroundColor = const Color(0xFF191414);
      });
    }
  }

  @override
  void dispose() {
    _tracker.removeListener(_onTrackChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<TrackProvider>();
    final player = tracker.player;

    // Always display the currently playing queue song.
    final currentSong = tracker.currentSong ?? widget.song;

    final isLiked = tracker.likedSongs().any(
      (song) => song['id'] == currentSong.id,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,

      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Recommended for you",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),

      body: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundColor,
              Color.lerp(backgroundColor, const Color(0xFF191414), 0.65)!,
              Colors.black,
            ],
            stops: const [0.0, 0.55, 1.0],
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 22,
                        shadowColor: Colors.black,
                        borderOnForeground: true,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: currentSong.artwork ?? '',
                            fit: BoxFit.cover,
                            height: MediaQuery.sizeOf(context).height / 2.5,
                            width: MediaQuery.sizeOf(context).width / 1.2,
                            errorWidget: (context, url, error) {
                              return Container(
                                color: const Color.fromARGB(225, 160, 160, 160),
                                child: const Center(
                                  child: Icon(
                                    Icons.music_note,
                                    size: 110,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.title.length > 13
                                ? "${currentSong.title.substring(0, 13)}..."
                                : currentSong.title,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.auto_awesome_rounded,
                                color: Color.fromARGB(255, 94, 209, 98),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                currentSong.artist.length > 20
                                    ? "${currentSong.artist.substring(0, 20)}..."
                                    : currentSong.artist,
                                maxLines: 1,
                                style: const TextStyle(
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
                          const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 30,
                          ),

                          const SizedBox(width: 11),

                          GestureDetector(
                            onTap: () async {
                              log("Like the song pressed");

                              if (!isLiked) {
                                await tracker.saveLikedSongs(currentSong);
                              } else {
                                await tracker.removeLikedSong(currentSong.id);
                              }

                              if (!mounted) return;

                              setState(() {});

                              log(tracker.likedSongs().length.toString());
                            },
                            child: isLiked
                                ? Lottie.asset(
                                    'assets/animations/Done.json',
                                    width: 37.5,
                                    height: 37.5,
                                    repeat: false,
                                  )
                                : const Icon(
                                    Icons.add_circle_outline_rounded,
                                    color: Colors.white,
                                    size: 33,
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
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        FormatDuration(duration),
                                        style: const TextStyle(
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
                      GestureDetector(
                        onTap: () async {
                          try {
                            await tracker.downloadSong(currentSong);

                            if (!context.mounted) return;

                            final downloaded = await tracker.isDownloaded(
                              currentSong.id,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  downloaded
                                      ? 'Song downloaded successfully'
                                      : 'Download did not complete',
                                ),
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Download failed: $e')),
                            );
                          }
                        },
                        child: const Icon(
                          Icons.install_mobile,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),

                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await tracker.playPreviousInQueue();
                            },
                            child: const Icon(
                              Icons.skip_previous_rounded,
                              size: 45,
                              color: Colors.white,
                            ),
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
                              size: 76,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 10),

                          GestureDetector(
                            onTap: () async {
                              await tracker.playNextInQueue();
                            },
                            child: const Icon(
                              Icons.skip_next_rounded,
                              size: 45,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const Icon(
                        Icons.timer_outlined,
                        size: 28,
                        color: Colors.white,
                      ),
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
