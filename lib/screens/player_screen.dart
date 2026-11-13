import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
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

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  String FormatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  Color backgroundColor = Colors.black;

  late TrackProvider _tracker;
  String? _lastSongId;

  late AnimationController _dismissController;

  final ScrollController _scrollController = ScrollController();

  bool _isDismissing = false;
  bool _isDragging = false;

  int? _activePointer;

  double _startY = 0;
  double _lastY = 0;

  Duration _lastMoveTime = Duration.zero;

  @override
  void initState() {
    super.initState();

    _tracker = context.read<TrackProvider>();

    final initialSong = _tracker.currentSong ?? widget.song;

    _lastSongId = initialSong.id;
    _tracker.addListener(_onTrackChanged);

    getBackgroundColor(initialSong.artwork, initialSong.id);

    _dismissController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      value: 0,
    );
  }

  // Detect queue changes.
  void _onTrackChanged() {
    final currentSong = _tracker.currentSong;

    if (currentSong == null || currentSong.id == _lastSongId) {
      return;
    }

    _lastSongId = currentSong.id;
    getBackgroundColor(currentSong.artwork, currentSong.id);
  }

  // Extract artwork color.
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

      if (!mounted || _lastSongId != songId) return;

      setState(() {
        backgroundColor = selectedColor;
      });
    } catch (e) {
      log("Palette extraction error: $e");

      if (!mounted || _lastSongId != songId) return;

      setState(() {
        backgroundColor = const Color(0xFF191414);
      });
    }
  }

  // Check whether the player content is at the top.
  bool get _isScrollAtTop {
    if (!_scrollController.hasClients) return true;

    return _scrollController.offset <=
        _scrollController.position.minScrollExtent + 1;
  }

  // A touch can begin anywhere on the screen.
  void _onPointerDown(PointerDownEvent event) {
    if (_isDismissing) return;

    _activePointer = event.pointer;
    _startY = event.position.dy;
    _lastY = event.position.dy;
    _lastMoveTime = event.timeStamp;

    _isDragging = false;
  }

  // Track raw movement without competing with Slider or ScrollView.
  void _onPointerMove(PointerMoveEvent event) {
    if (_isDismissing || event.pointer != _activePointer) return;

    final currentY = event.position.dy;
    final totalDistance = currentY - _startY;

    // Only activate on a downward swipe.
    if (!_isDragging) {
      if (totalDistance < 8) return;

      // Let the user scroll normally when content isn't at the top.
      if (!_isScrollAtTop) return;

      _isDragging = true;
      _dismissController.stop();
    }

    if (_isDragging) {
      final screenHeight = MediaQuery.sizeOf(context).height;

      _dismissController.value = (totalDistance / screenHeight).clamp(0.0, 1.0);
    }

    _lastY = currentY;
    _lastMoveTime = event.timeStamp;
  }

  // Finish the gesture.
  void _onPointerUp(PointerUpEvent event) {
    if (event.pointer != _activePointer) return;

    if (!_isDragging) {
      _resetPointer();
      return;
    }

    final elapsed = event.timeStamp - _lastMoveTime;

    final distance = event.position.dy - _lastY;

    final velocity = elapsed.inMicroseconds > 0
        ? distance / elapsed.inMicroseconds * 1000000
        : 0.0;

    _resetPointer();

    _finishDrag(velocity);
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (event.pointer != _activePointer) return;

    final wasDragging = _isDragging;
    _resetPointer();

    if (wasDragging && !_isDismissing) {
      _dismissController.animateBack(
        0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _resetPointer() {
    _activePointer = null;
    _isDragging = false;
  }

  Future<void> _finishDrag(double velocity) async {
    if (_isDismissing) return;

    if (_dismissController.value > 0.18 || velocity > 900) {
      await _dismissPlayer();
    } else {
      await _dismissController.animateBack(
        0,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    }
  }

  // Complete dismissal.
  Future<void> _dismissPlayer() async {
    if (_isDismissing) return;

    _isDismissing = true;

    final remaining = 1.0 - _dismissController.value;

    final duration = Duration(
      milliseconds: (220 * remaining).round().clamp(80, 220),
    );

    await _dismissController.animateTo(
      1,
      duration: duration,
      curve: Curves.easeOutCubic,
    );

    if (!mounted) return;

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _tracker.removeListener(_onTrackChanged);

    _scrollController.dispose();
    _dismissController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<TrackProvider>();
    final player = tracker.player;

    final currentSong = tracker.currentSong ?? widget.song;

    final isLiked = tracker.likedSongs().any(
      (song) => song['id'] == currentSong.id,
    );

    final screenHeight = MediaQuery.sizeOf(context).height;

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,

      child: AnimatedBuilder(
        animation: _dismissController,

        builder: (context, child) {
          final progress = Curves.easeOut.transform(_dismissController.value);

          final scale = 1 - (progress * 0.035);

          return Transform.translate(
            offset: Offset(0, screenHeight * _dismissController.value),
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topCenter,
              child: child,
            ),
          );
        },

        child: Scaffold(
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
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.more_vert),
              ),
            ],
          ),

          body: AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOutCubic,
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  backgroundColor,
                  Color.lerp(backgroundColor, const Color(0xFF191414), 0.65)!,
                  Colors.black,
                ],
                stops: const [0, 0.55, 1],
              ),
            ),

            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 5,
                ),

                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),

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
                                    color: const Color.fromARGB(
                                      225,
                                      160,
                                      160,
                                      160,
                                    ),
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
                                  if (!isLiked) {
                                    await tracker.saveLikedSongs(currentSong);
                                  } else {
                                    await tracker.removeLikedSong(
                                      currentSong.id,
                                    );
                                  }

                                  if (!mounted) return;

                                  setState(() {});
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

                      SizedBox(
                        width: double.infinity,
                        child: StreamBuilder<Duration>(
                          stream: player.positionStream,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            final duration = player.duration ?? Duration.zero;

                            final maxDuration = duration.inSeconds.toDouble();

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
                                    max: maxDuration > 0 ? maxDuration : 1,
                                    value: position.inSeconds.toDouble().clamp(
                                      0,
                                      maxDuration > 0 ? maxDuration : 1,
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
                                    horizontal: 7,
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

                                if (!context.mounted) return;

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
                                  SnackBar(
                                    content: Text('Download failed: $e'),
                                  ),
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

                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
