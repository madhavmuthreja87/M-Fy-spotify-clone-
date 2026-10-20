import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sf/models/track_model.dart';
import 'package:sf/providers/track_provider.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  late Future<List<Map<String, dynamic>>> _downloadsFuture;

  @override
  void initState() {
    super.initState();
    _loadDownloads();
  }

  void _loadDownloads() {
    _downloadsFuture = context.read<TrackProvider>().getDownloadedSongs();
  }

  Future<void> _refreshDownloads() async {
    setState(_loadDownloads);
    await _downloadsFuture;
  }

  Future<void> _playSong(Map<String, dynamic> song) async {
    final tracker = context.read<TrackProvider>();

    final String? path = song['localPath']?.toString();
    final String title = song['title']?.toString() ?? 'Unknown song';

    if (path == null || path.trim().isEmpty) {
      _showMessage('Downloaded file path is missing.');
      return;
    }

    final String localPath = path.trim();

    try {
      final File audioFile = File(localPath);

      if (!await audioFile.exists()) {
        if (!mounted) return;

        _showMessage('Audio file not found. Refreshing downloads.');
        await _refreshDownloads();
        return;
      }

      if (await audioFile.length() == 0) {
        if (!mounted) return;

        _showMessage('This downloaded audio file is empty.');
        return;
      }

      // Convert the saved Hive data into a TrackModel.
      final TrackModel track = TrackModel(
        id: song['id']?.toString() ?? '',
        title: title,
        artist: song['artist']?.toString() ?? 'Unknown artist',
        artwork: song['artwork']?.toString(),
        duration: song['duration'] ?? 0,
        streamUrl: localPath,
        isStreamable: '',
      );

      // Pass both required arguments.
      await tracker.playDownloadedSong(track, localPath);

      if (!mounted) return;

      _showMessage('Playing $title');
    } catch (error, stackTrace) {
      debugPrint('Error playing downloaded song: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      _showMessage('Could not play song: $error');
    }
  }

  Future<void> _deleteSong(Map<String, dynamic> song) async {
    final tracker = context.read<TrackProvider>();
    final id = song['id']?.toString();

    if (id == null || id.isEmpty) {
      _showMessage('Song ID is missing.');
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete download?'),
        content: Text(
          'Remove "${song['title'] ?? 'this song'}" from downloads?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await tracker.removeDownload(id);

      if (!mounted) return;
      setState(_loadDownloads);
      _showMessage('Download deleted.');
    } catch (e) {
      if (!mounted) return;
      _showMessage('Could not delete download: $e');
    }
  }

  void _cancelDownload(String id) {
    context.read<TrackProvider>().cancelDownload(id);
    _showMessage('Cancelling download...');
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<TrackProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Downloads',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh downloads',
            onPressed: () => setState(_loadDownloads),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _downloadsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 12),
                  const Text('Could not load downloads.'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => setState(_loadDownloads),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final songs = snapshot.data ?? <Map<String, dynamic>>[];

          if (songs.isEmpty && tracker.downloadingSongIds.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshDownloads,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 140),
                  Icon(Icons.download_for_offline_outlined, size: 64),
                  SizedBox(height: 16),
                  Center(child: Text('No downloaded songs yet')),
                  SizedBox(height: 8),
                  Center(child: Text('Download a song to listen offline.')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshDownloads,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 0),
              children: [
                // Active downloads
                ...tracker.downloadingSongIds.map((id) {
                  final progress = tracker.downloadProgress[id] ?? 0.0;

                  return ListTile(
                    leading: const SizedBox(
                      width: 48,
                      height: 30,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    ),
                    title: Text(
                      _titleForId(id, songs),
                      style: TextStyle(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Downloading...'),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: progress > 0 ? progress : null,
                        ),
                        if (progress > 0)
                          Text('${(progress * 100).toStringAsFixed(0)}%'),
                      ],
                    ),
                    trailing: IconButton(
                      tooltip: 'Cancel download',
                      icon: const Icon(Icons.close),
                      onPressed: () => _cancelDownload(id),
                    ),
                  );
                }),

                // Completed downloads
                ...songs.map((song) {
                  final id = song['id']?.toString() ?? '';
                  final artwork = song['artwork']?.toString() ?? '';

                  return ListTile(
                    key: ValueKey(id),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: artwork.isNotEmpty
                          ? Image.network(
                              artwork,
                              width: 47,
                              height: 47,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _musicIcon(),
                            )
                          : _musicIcon(),
                    ),
                    title: Text(
                      song['title']?.toString() ?? 'Unknown song',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.7,
                      ),
                    ),
                    subtitle: Text(
                      song['artist']?.toString() ?? 'Unknown artist',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _playSong(song),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'play') {
                          _playSong(song);
                        } else if (value == 'delete') {
                          _deleteSong(song);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'play',
                          child: Row(
                            children: [
                              Icon(Icons.play_arrow),
                              SizedBox(width: 12),
                              Text('Play'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline),
                              SizedBox(width: 12),
                              Text('Delete download'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  String _titleForId(String id, List<Map<String, dynamic>> songs) {
    for (final song in songs) {
      if (song['id']?.toString() == id) {
        return song['title']?.toString() ?? 'Downloading song';
      }
    }

    return 'Downloading song';
  }

  Widget _musicIcon() {
    return Container(
      width: 52,
      height: 52,
      color: Colors.grey.shade900,
      child: const Icon(Icons.music_note, color: Colors.white),
    );
  }
}
