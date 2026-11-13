import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sf/models/track_model.dart';
import 'package:sf/providers/track_provider.dart';

class RecentsInDrawer extends StatefulWidget {
  const RecentsInDrawer({super.key});

  @override
  State<RecentsInDrawer> createState() => _RecentsInDrawerState();
}

class _RecentsInDrawerState extends State<RecentsInDrawer> {
  // Convert Hive playedAt value into DateTime
  DateTime? getPlayedDate(dynamic playedAt) {
    if (playedAt == null) return null;

    if (playedAt is int) {
      return DateTime.fromMillisecondsSinceEpoch(playedAt);
    }

    if (playedAt is DateTime) {
      return playedAt;
    }

    if (playedAt is String) {
      return DateTime.tryParse(playedAt);
    }

    return null;
  }

  // Group songs according to their played date
  Map<DateTime, List<Map<String, dynamic>>> groupSongsByDate(
    List<dynamic> songs,
  ) {
    final Map<DateTime, List<Map<String, dynamic>>> groupedSongs = {};

    for (final song in songs) {
      final songMap = Map<String, dynamic>.from(song as Map);

      final playedDate = getPlayedDate(songMap['playedAt']);

      if (playedDate == null) continue;

      final dateKey = DateTime(
        playedDate.year,
        playedDate.month,
        playedDate.day,
      );

      groupedSongs.putIfAbsent(dateKey, () => []);
      groupedSongs[dateKey]!.add(songMap);
    }

    // Sort songs within each date: newest first
    for (final songsList in groupedSongs.values) {
      songsList.sort((a, b) {
        final dateA = getPlayedDate(a['playedAt']);
        final dateB = getPlayedDate(b['playedAt']);

        return (dateB ?? DateTime(1970)).compareTo(dateA ?? DateTime(1970));
      });
    }

    // Sort dates: newest first
    final sortedEntries = groupedSongs.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return Map.fromEntries(sortedEntries);
  }

  // Display readable date headers
  String formatDate(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) {
      return 'Today';
    }

    if (date == yesterday) {
      return 'Yesterday';
    }

    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'March',
      'April',
      'May',
      'June',
      'July',
      'Aug',
      'Sept',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        centerTitle: true,
        title: const Text(
          'Recents',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Consumer<TrackProvider>(
          builder: (context, player, child) {
            final recentSongs = player.recentSongs();
            final likedSongs = player.likedSongs();

            if (recentSongs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(18),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Play what you love',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Text(
                      //   'Search for artists, songs, playlists, podcasts and more.',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(color: Colors.grey, fontSize: 15.5),
                      // ),
                    ],
                  ),
                ),
              );
            }

            // Group songs after fetching from Provider
            final groupedSongs = groupSongsByDate(recentSongs);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: const Color.fromARGB(71, 158, 158, 158),
                    ),
                    child: const Text(
                      'Music',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView(
                      children: [
                        ...groupedSongs.entries.map((entry) {
                          final date = entry.key;
                          final songs = entry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date header
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 15,
                                  bottom: 8,
                                  left: 4,
                                ),
                                child: Text(
                                  formatDate(date),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              // Songs for this date
                              ...songs.map((recentContent) {
                                final isLiked = likedSongs.any(
                                  (song) => song['id'] == recentContent['id'],
                                );

                                final currentTrack = TrackModel(
                                  id: recentContent['id']?.toString() ?? '',
                                  title:
                                      recentContent['title']?.toString() ?? '',
                                  artist:
                                      recentContent['artist']?.toString() ?? '',

                                  // duration must be int
                                  duration: recentContent['duration'] is int
                                      ? recentContent['duration']
                                      : int.tryParse(
                                              recentContent['duration']
                                                      ?.toString() ??
                                                  '',
                                            ) ??
                                            0,

                                  isStreamable:
                                      recentContent['is_streamable']
                                          ?.toString() ??
                                      recentContent['isStreamable']
                                          ?.toString() ??
                                      '',

                                  artwork: recentContent['artwork']?.toString(),
                                  streamUrl: recentContent['streamUrl']
                                      ?.toString(),
                                );
                                return GestureDetector(
                                  onTap: () {
                                    player.setSongAndPlay(currentTrack);
                                  },
                                  child: SizedBox(
                                    height: 80,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              recentContent['artwork']
                                                  ?.toString() ??
                                              '',
                                          fit: BoxFit.cover,
                                          height: 65,
                                          width: 65,
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
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      title: Text(
                                        recentContent['title']?.toString() ??
                                            '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        recentContent['artist']?.toString() ??
                                            '',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_drop_down_circle_outlined,
                                        size: 18,
                                        color: const Color.fromARGB(
                                          255,
                                          186,
                                          185,
                                          185,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          );
                        }),

                        const SizedBox(height: 25),

                        // Clear recent songs
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              showAdaptiveDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return AlertDialog.adaptive(
                                    backgroundColor: const Color(0xFF121212),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    content: const Text(
                                      'Are you sure you want to clear your recent searches?',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                        },
                                        child: const Text(
                                          'CANCEL',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await player.removeAllrecentSong();

                                          if (dialogContext.mounted) {
                                            Navigator.pop(dialogContext);
                                          }
                                        },
                                        child: const Text(
                                          'CLEAR',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: const Text(
                                'Clear recent searches',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
