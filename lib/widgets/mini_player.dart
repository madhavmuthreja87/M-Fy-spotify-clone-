import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator_plus/palette_generator_plus.dart';
import 'package:provider/provider.dart';
import 'package:sf/providers/track_provider.dart';
import 'package:sf/screens/player_screen.dart';
import 'package:sf/models/track_model.dart';

class MiniPlayer extends StatefulWidget {
  final TrackModel song;

  final VoidCallback onPlayPause;
  final VoidCallback onTap;

  const MiniPlayer({
    super.key,
    required this.song,
    required this.onPlayPause,
    required this.onTap,
  });

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  Color backgroundColor = const Color(0xFF212121);

  int _paletteRequestId = 0;

  String? _lastSongId;

  late TrackProvider _tracker;

  @override
  void initState() {
    super.initState();

    _tracker = context.read<TrackProvider>();

    final initialSong = _tracker.currentSong ?? widget.song;

    _lastSongId = initialSong.id;

    _tracker.addListener(_onTrackChanged);

    getBackgroundColor(initialSong.artwork, initialSong.id);
  }

  // Detect actual song changes, including queue changes.
  void _onTrackChanged() {
    final song = _tracker.currentSong;

    if (song == null || song.id == _lastSongId) return;

    _lastSongId = song.id;

    getBackgroundColor(song.artwork, song.id);
  }

  // Extract artwork color.
  Future<void> getBackgroundColor(String? artwork, String songId) async {
    final requestId = ++_paletteRequestId;

    if (artwork == null || artwork.isEmpty) {
      if (!mounted || requestId != _paletteRequestId) return;

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

      if (!mounted || requestId != _paletteRequestId || _lastSongId != songId) {
        return;
      }

      setState(() {
        backgroundColor = selectedColor;
      });
    } catch (e) {
      log("MiniPlayer palette error: $e");

      if (!mounted || requestId != _paletteRequestId || _lastSongId != songId) {
        return;
      }

      setState(() {
        backgroundColor = const Color(0xFF191414);
      });
    }
  }

  @override
  void didUpdateWidget(covariant MiniPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Fallback if the parent updates the song property.
    if (oldWidget.song.id != widget.song.id &&
        _tracker.currentSong?.id == widget.song.id) {
      if (_lastSongId != widget.song.id) {
        _lastSongId = widget.song.id;

        getBackgroundColor(widget.song.artwork, widget.song.id);
      }
    }
  }

  @override
  void dispose() {
    _tracker.removeListener(_onTrackChanged);
    _paletteRequestId++;

    super.dispose();
  }

  void _openPlayer() {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (context, animation, secondaryAnimation) {
          return PlayerScreen(song: _tracker.currentSong ?? widget.song);
        },
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 280),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );

          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Only rebuild for the properties MiniPlayer needs.
    final isPlaying = context.select<TrackProvider, bool>(
      (provider) => provider.isPlaying,
    );

    final currentSong = context.select<TrackProvider, TrackModel?>(
      (provider) => provider.currentSong,
    );

    final player = context.read<TrackProvider>().player;

    final song = currentSong ?? widget.song;

    return GestureDetector(
      onTap: _openPlayer,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),

        child: Container(
          height: MediaQuery.sizeOf(context).height / 14.4,
          width: MediaQuery.sizeOf(context).width / 1.07,

          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),

          padding: const EdgeInsets.symmetric(horizontal: 6),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),

                          child: CachedNetworkImage(
                            key: ValueKey(song.id),
                            imageUrl: song.artwork ?? '',
                            fit: BoxFit.cover,
                            height: MediaQuery.sizeOf(context).height / 19.29,
                            width: MediaQuery.sizeOf(context).height / 19.29,
                            errorWidget: (context, url, error) {
                              return Container(
                                color: const Color.fromARGB(225, 160, 160, 160),
                                child: const Center(
                                  child: Icon(
                                    Icons.music_note,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 8),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              song.title.length > 20
                                  ? "${song.title.substring(0, 20)}..."
                                  : song.title,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            Text(
                              song.artist,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11.7,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (isPlaying) {
                          _tracker.pause();
                        } else {
                          _tracker.resume();
                        }
                      },
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                        size: 34,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),

                child: SizedBox(
                  width: double.infinity,

                  child: StreamBuilder<Duration>(
                    stream: player.positionStream,

                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;

                      final duration = player.duration ?? Duration.zero;

                      final maxDuration = duration.inSeconds.toDouble();

                      return SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                          trackShape: const RoundedRectSliderTrackShape(),
                          thumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey,
                          activeTrackColor: Colors.white,
                          trackHeight: 0.015,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 0,
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
                            player.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
