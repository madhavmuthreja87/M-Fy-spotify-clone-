import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';

import 'package:sf/services/audio_handler.dart';
import 'package:sf/services/audis_api.dart';
import 'package:sf/models/track_model.dart';
import 'package:sf/services/youtube_services.dart';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:flutter/widgets.dart';

import 'package:sf/models/track_model.dart';
import 'package:sf/services/download_service.dart';

class TrackProvider extends ChangeNotifier {
  final MyAudioHandler handler;
  AudioPlayer get player => handler.player;

  TrackModel? currentSong;
  bool isPlaying = false;

  List<TrackModel> trendingSongsList = [];
  List<TrackModel> latestSongsList = [];
  List<TrackModel> _queue = [];
  List<TrackModel> get queue => _queue;

  final Box recentBox = Hive.box("recentSongs");
  final Box likedBox = Hive.box("likedSongs");
  final Box playlistBox = Hive.box("playlistBox");
  final Box mostPlayedBox = Hive.box("mostPlayedBox");
  final Box downloadedSongsBox = Hive.box('downloadedSongs');

  final YoutubeServices _ytService = YoutubeServices();
  final DownloadService _downloadService = DownloadService();

  final Map<String, double> downloadProgress = {};
  final Map<String, CancelToken> _downloadTokens = {};
  final Set<String> downloadingSongIds = {};
  int _playToken = 0;

  String get userDocId {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    return "${user.email!.split('@').first}__${user.uid.substring(0, 3)}";
  }

  void addToQueue(TrackModel song) {
    queue.add(song);
    notifyListeners();
  }

  void removeFromQueue(int idx) {
    if (idx < 0 || idx >= queue.length) return;

    queue.removeAt(idx);
    notifyListeners();
  }

  void clearQueue() {
    queue.clear();
    currentQueueIndex = -1;
    notifyListeners();
  }

  int currentQueueIndex = -1;

  Future<void> playNextInQueue() async {
    if (_queue.isEmpty) {
      log('NEXT: Queue is empty');
      return;
    }

    final int nextIndex;

    if (currentQueueIndex == -1) {
      // If the current song is in the queue, start after it.
      final currentIndex = _queue.indexWhere(
        (song) => song.id == currentSong?.id,
      );

      nextIndex = currentIndex == -1 ? 0 : currentIndex + 1;
    } else {
      nextIndex = currentQueueIndex + 1;
    }

    if (nextIndex >= _queue.length) {
      log('NEXT: Already at the end of the queue');
      return;
    }

    currentQueueIndex = nextIndex;
    log('NEXT: Playing queue index $currentQueueIndex');
    await setSongAndPlay(_queue[currentQueueIndex]);
  }

  Future<void> playPreviousInQueue() async {
    if (_queue.isEmpty) {
      log('PREVIOUS: Queue is empty');
      return;
    }

    final int previousIndex;

    if (currentQueueIndex == -1) {
      final currentIndex = _queue.indexWhere(
        (song) => song.id == currentSong?.id,
      );

      previousIndex = currentIndex == -1 ? -1 : currentIndex - 1;
    } else {
      previousIndex = currentQueueIndex - 1;
    }

    if (previousIndex < 0 || previousIndex >= _queue.length) {
      log('PREVIOUS: Already at the beginning of the queue');
      return;
    }

    currentQueueIndex = previousIndex;
    log('PREVIOUS: Playing queue index $currentQueueIndex');
    await setSongAndPlay(_queue[currentQueueIndex]);
  }

  TrackProvider(this.handler) {
    handler.onNext = () async {
      log('TRACK PROVIDER: onNext callback received');
      await playNextInQueue();
    };

    handler.onPrevious = () async {
      log('TRACK PROVIDER: onPrevious callback received');
      await playPreviousInQueue();
    };

    log('TRACK PROVIDER: callbacks registered');

    player.playingStream.listen((playing) {
      if (_playToken == 0) return; // ignore initial
      isPlaying = playing;
      notifyListeners();
    });

    player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        playNextInQueue();
      }
    });
  }

  bool _isYoutubeId(String id) => RegExp(r'^[A-Za-z0-9_-]{11}$').hasMatch(id);

  // --- CORE: AUDIO ONLY ---
  Future<void> setSongAndPlay(TrackModel song) async {
    final token = ++_playToken;
    currentSong = song;
    isPlaying = false;
    notifyListeners();

    try {
      // 1. Update lockscreen / notification instantly
      handler.mediaItem.add(
        MediaItem(
          id: song.id.toString(),
          title: song.title,
          artist: song.artist,
          artUri: Uri.tryParse(song.artwork ?? ''),
          duration: Duration(seconds: int.tryParse('${song.duration}') ?? 0),
        ),
      );

      await saveRecentSongs(song);
      if (token != _playToken) return; // new tap came

      if (_isYoutubeId(song.id)) {
        log('YT AUDIO: ${song.id} - ${song.title}');
        // This MUST do: get manifest -> audioOnly -> setAudioSource -> play
        await _ytService.getAudioStream(
          song.id,
          player,
          forceRefresh: true, // always fresh url, yt urls expire in ~6hr
        );
        isPlaying = true;
        notifyListeners();
      } else {
        log('AUDIUS AUDIO: ${song.id}');
        final freshUrl = await AudisApi().getFreshStreamUrl(song.id);
        if (token != _playToken) return;
        await player.setUrl(freshUrl);
        await player.play();
        isPlaying = true;
        notifyListeners();
      }

      if (token != _playToken) return;

      // 2. Only count after actual play started
      if (player.playing) {
        await recordSongPlayedCount(song);
      }
    } catch (e, st) {
      log('PLAY ERROR: $e\n$st');
      if (token == _playToken) {
        isPlaying = false;
        currentSong = null;
        notifyListeners();
      }
    }
  }

  Future<void> pause() async {
    await handler.pause();
  }

  Future<void> resume() async {
    await handler.play();
  }

  Future<void> stop() async {
    await handler.stop();
  }

  // --- REST UNCHANGED ---
  Future<void> saveRecentSongs(TrackModel song) async {
    await recentBox.delete(song.id);
    await recentBox.put(song.id, {
      'id': song.id,
      'title': song.title,
      'artist': song.artist,
      'duration': song.duration,
      'is_streamable': song.isStreamable,
      'artwork': song.artwork,
      'streamUrl': song.streamUrl,
      'playedAt': DateTime.now().millisecondsSinceEpoch,
    });

    await saveSongToCloudRecents('recents', song);
  }

  Future<void> saveSongToCloudRecents(
    String collection,
    TrackModel song,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userDocId)
        .collection(collection)
        .doc(song.id)
        .set({
          'id': song.id,
          'title': song.title,
          'artist': song.artist,
          'duration': song.duration,
          'is_streamable': song.isStreamable,
          'artwork': song.artwork,
          'playedAt': FieldValue.serverTimestamp(),
        });
  }

  Future<void> recordSongPlayedCount(TrackModel song) async {
    final existing = mostPlayedBox.get(song.id);
    final currentCount = existing == null
        ? 0
        : (existing['playCount'] as int? ?? 0);
    await mostPlayedBox.put(song.id, {
      'id': song.id,
      'title': song.title,
      'artist': song.artist,
      'duration': song.duration,
      'is_streamable': song.isStreamable,
      'artwork': song.artwork,
      'streamUrl': song.streamUrl,
      'playCount': currentCount + 1,
    });
    notifyListeners();
  }

  Future<void> fetchTrendingSongs() async {
    try {
      trendingSongsList = await AudisApi().getTrendingTracks();
      notifyListeners();
    } catch (e) {
      log("Error fetching trending: $e");
    }
  }

  List<TrackModel> trendingSongs() => trendingSongsList;

  Future<void> fetchLatestSongs() async {
    try {
      latestSongsList = await AudisApi().getLatestTracks();
      notifyListeners();
    } catch (e) {
      log("Error fetching latest: $e");
    }
  }

  List<TrackModel> LatestSongs() => latestSongsList;

  List<Map> mostPlayedSong() {
    final songs = mostPlayedBox.values
        .map((s) => Map<String, dynamic>.from(s))
        .toList();
    songs.sort(
      (a, b) => (b['playCount'] as int).compareTo(a['playCount'] as int),
    );
    return songs.take(7).toList();
  }

  List<Map> recentSongs() {
    final songs = recentBox.values
        .map((s) => Map<String, dynamic>.from(s))
        .toList();
    songs.sort((a, b) => b['playedAt'].compareTo(a['playedAt']));
    return songs;
  }

  Future<void> removeRecentSong(String id) async {
    await recentBox.delete(id);
    notifyListeners();
  }

  Future<void> removeAllrecentSong() async {
    await recentBox.clear();
    notifyListeners();
  }

  Future<void> saveLikedSongs(TrackModel song) async {
    await likedBox.put(song.id, {
      'id': song.id,
      'title': song.title,
      'artist': song.artist,
      'duration': song.duration,
      'is_streamable': song.isStreamable,
      'artwork': song.artwork,
      'streamUrl': song.streamUrl,
    });
    notifyListeners();
  }

  List<Map> likedSongs() =>
      likedBox.values.map((s) => Map<String, dynamic>.from(s)).toList();

  Future<void> removeLikedSong(String id) async {
    await likedBox.delete(id);
    notifyListeners();
  }

  Future<void> createPlaylist(String pname) async {
    await playlistBox.put(pname, []);
    notifyListeners();
  }

  Future<void> removePlaylist(String pname) async {
    await playlistBox.delete(pname);
    notifyListeners();
  }

  Future<void> addToPlaylist(String pname, TrackModel tm) async {
    final existing = List<Map>.from(
      playlistBox.get(pname, defaultValue: <Map>[]),
    );
    existing.add({
      'id': tm.id,
      'title': tm.title,
      'artist': tm.artist,
      'duration': tm.duration,
      'is_streamable': tm.isStreamable,
      'artwork': tm.artwork,
      'streamUrl': tm.streamUrl,
    });
    await playlistBox.put(pname, existing);

    await saveSongToCloudPlaylist('playlists', pname, tm);
    notifyListeners();
  }

  Future<void> saveSongToCloudPlaylist(
    String collection,
    String pname,
    TrackModel song,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userDocId)
        .collection(collection)
        .doc(pname)
        .collection('songs')
        .doc(song.id)
        .set({
          'id': song.id,
          'title': song.title,
          'artist': song.artist,
          'duration': song.duration,
          'is_streamable': song.isStreamable,
          'artwork': song.artwork,
          'playedAt': FieldValue.serverTimestamp(),
        });
  }

  Future<void> removeFromPlaylist(String pname, String songID) async {
    final existing = List<Map>.from(
      playlistBox.get(pname, defaultValue: <Map>[]),
    );
    existing.removeWhere((s) => s['id'] == songID);
    await playlistBox.put(pname, existing);
    notifyListeners();
  }

  List<String> allplaylistsName() => playlistBox.keys.cast<String>().toList();
  List<Map> songsOfPlaylist(String pname) =>
      List<Map>.from(playlistBox.get(pname, defaultValue: <Map>[]));

  Future<void> addTemporaryMostPlayedData() async {
    await mostPlayedBox.clear();
    for (int i = 1; i <= 7; i++) {
      await mostPlayedBox.put('song$i', {
        'id': 'song$i',
        'title': 'Test Song $i',
        'artist': 'Artist $i',
        'duration': 200,
        'is_streamable': 'true',
        'artwork': 'https://picsum.photos/300?$i',
        'streamUrl': 'https://example.com/song$i.mp3',
        'playCount': i == 7 ? 2 : 1,
      });
    }
    notifyListeners();
  }

  /// Returns true only if the saved audio file still exists.
  Future<bool> isDownloaded(String songId) async {
    final box = await downloadedSongsBox;
    final data = box.get(songId);

    if (data is! Map) return false;

    final path = data['localPath'];

    if (path is! String || path.isEmpty) return false;

    return File(path).exists();
  }

  /// Returns saved download metadata for the Downloads screen.
  Future<List<Map<String, dynamic>>> getDownloadedSongs() async {
    final box = await downloadedSongsBox;
    final result = <Map<String, dynamic>>[];

    for (final key in box.keys.toList()) {
      final data = box.get(key);

      if (data is! Map) continue;

      final song = Map<String, dynamic>.from(data);
      final path = song['localPath'];

      if (path is String && await File(path).exists()) {
        result.add(song);
      } else {
        // Remove metadata for files that no longer exist.
        await box.delete(key);
      }
    }

    return result;
  }

  /// Downloads a direct audio URL that the source permits saving.

  Future<void> downloadSong(TrackModel track) async {
    final id = track.id;

    if (downloadingSongIds.contains(id)) {
      log('Download already in progress: $id');
      return;
    }

    if (await isDownloaded(id)) {
      log('Song already downloaded: ${track.title}');
      return;
    }

    final cancelToken = CancelToken();

    downloadingSongIds.add(id);
    _downloadTokens[id] = cancelToken;
    downloadProgress[id] = 0.0;
    notifyListeners();

    try {
      String url;

      if (_isYoutubeId(id)) {
        // Resolve a fresh YouTube audio URL.
        final uri = await _ytService.resolveAudioUri(id, forceRefresh: true);
        url = uri.toString();
        log('YT DOWNLOAD: resolved audio URL for ${track.title}');
      } else {
        // Audius tracks use their existing direct stream URL.
        url = track.streamUrl?.trim() ?? '';

        if (url.isEmpty) {
          throw Exception('No download URL available for ${track.title}.');
        }
      }

      final safeId = id.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');

      double lastNotifiedProgress = -1.0;

      final localPath = await _downloadService.downloadAudio(
        url: url,
        fileName: '$safeId.audio',
        cancelToken: cancelToken,
        onProgress: (progress) {
          final normalized = progress.clamp(0.0, 1.0).toDouble();

          if (lastNotifiedProgress < 0 ||
              normalized - lastNotifiedProgress >= 0.01 ||
              normalized >= 1.0) {
            lastNotifiedProgress = normalized;
            downloadProgress[id] = normalized;
            notifyListeners();
          }
        },
      );

      final file = File(localPath);

      if (!await file.exists() || await file.length() == 0) {
        throw Exception('Downloaded file is missing or empty.');
      }

      await downloadedSongsBox.put(id, {
        'id': track.id,
        'title': track.title,
        'artist': track.artist,
        'duration': track.duration,
        'artwork': track.artwork ?? '',
        'source': _isYoutubeId(id) ? 'youtube' : 'audius',
        'localPath': localPath,
      });

      await downloadedSongsBox.flush();

      log('DOWNLOAD SUCCESS: ${track.title}');
      log('Saved path: $localPath');
    } catch (e, stackTrace) {
      log('DOWNLOAD FAILED: ${track.title}', error: e, stackTrace: stackTrace);
      rethrow;
    } finally {
      downloadingSongIds.remove(id);
      _downloadTokens.remove(id);
      downloadProgress.remove(id);
      notifyListeners();
    }
  }

  /// Cancels an active download.
  void cancelDownload(String songId) {
    _downloadTokens[songId]?.cancel('Download cancelled');
  }

  /// Removes the saved audio file and its Hive metadata.
  Future<void> removeDownload(String songId) async {
    final box = await downloadedSongsBox;
    final data = box.get(songId);

    if (data is Map && data['localPath'] is String) {
      await _downloadService.deleteAudio(data['localPath'] as String);
    }

    await box.delete(songId);
    notifyListeners();
  }

  Future<void> playDownloadedSong(TrackModel song, String localPath) async {
    final file = File(localPath);

    if (!await file.exists() || await file.length() == 0) {
      throw Exception('Downloaded audio file is missing or empty.');
    }

    final token = ++_playToken;

    currentSong = song;
    isPlaying = false;
    notifyListeners();

    try {
      handler.mediaItem.add(
        MediaItem(
          id: song.id,
          title: song.title,
          artist: song.artist,
          artUri: Uri.tryParse(song.artwork ?? ''),
          duration: Duration(seconds: int.tryParse('${song.duration}') ?? 0),
        ),
      );

      await saveRecentSongs(song);

      if (token != _playToken) return;

      await player.setAudioSource(AudioSource.file(localPath));

      if (token != _playToken) return;

      await player.play();

      isPlaying = player.playing;
      notifyListeners();

      if (player.playing) {
        await recordSongPlayedCount(song);
      }
    } catch (e, stack) {
      log('Downloaded playback failed: $e', stackTrace: stack);

      if (token == _playToken) {
        isPlaying = false;
        notifyListeners();
      }

      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
