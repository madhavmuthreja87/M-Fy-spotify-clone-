import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator_plus/palette_generator_plus.dart';
import 'package:provider/provider.dart';
import 'package:sf/providers/track_provider.dart';
import 'package:sf/screens/player_screen.dart';
import 'package:sf/models/track_model.dart';

class MiniPlayer extends StatefulWidget {
  final TrackModel song;

  final VoidCallback onPlayPause;
  final VoidCallback onTap;

  MiniPlayer({
    required this.song,

    required this.onPlayPause,
    required this.onTap,
  });

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  Color backgroundColor = const Color(0xFF212121);

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
  void didUpdateWidget(covariant MiniPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.song.id != widget.song.id) {
      getBackgroundColor();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<TrackProvider>();
    final player = tracker.player;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return PlayerScreen(song: widget.song);
            },
            transitionDuration: const Duration(milliseconds: 450),
            reverseTransitionDuration: const Duration(milliseconds: 380),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;

                  final tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.easeOutCubic));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        height: 54,
        width: MediaQuery.sizeOf(context).width / 1.09,
        decoration: BoxDecoration(
          color: backgroundColor.withValues(alpha: 1),
          //     gradient: LinearGradient(colors: [backgroundColor.withValues()]),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        // child: Image.network(
                        //   widget.song.artwork ?? "",
                        //   fit: BoxFit.cover,
                        //   height: 40,
                        //   width: 40,
                        // ),
                        child: CachedNetworkImage(
                          imageUrl: widget.song.artwork ?? "",
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
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
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            widget.song.title.length > 20
                                ? widget.song.title.substring(0, 20) + "..."
                                : widget.song.title,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.7,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            widget.song.artist,

                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11.7,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // Text(widget.song.artist),
                          // const SizedBox(height: 8),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    children: [
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
                              ? Icons.pause
                              : Icons.play_arrow_rounded,
                          size: 34,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0),
              child: SizedBox(
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
                            overlayShape: SliderComponentShape.noOverlay,
                            trackShape: const RoundedRectSliderTrackShape(),
                            thumbColor: Colors.white,
                            inactiveTrackColor: Colors.grey,
                            activeTrackColor: Colors.white,
                            trackHeight: 1.6,

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
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
