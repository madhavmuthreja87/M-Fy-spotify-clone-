import 'dart:async';
import 'dart:developer';

import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

class YoutubeServices {
  final yt.YoutubeExplode _yt = yt.YoutubeExplode();

  final Map<String, String> _urlCache = {};
  final Map<String, DateTime> _urlCacheTime = {};

  // Stream URLs are temporary. Use a short cache lifetime.
  static const Duration _cacheDuration = Duration(minutes: 3);
  static const Duration _requestTimeout = Duration(seconds: 30);

  bool _disposed = false;

  bool _isCacheValid(String id) {
    final cachedUrl = _urlCache[id];
    final cachedTime = _urlCacheTime[id];

    if (cachedUrl == null || cachedTime == null) return false;

    return DateTime.now().difference(cachedTime) < _cacheDuration;
  }

  void _clearCache(String id) {
    _urlCache.remove(id);
    _urlCacheTime.remove(id);
  }

  Future<List<yt.Video>> searchFromYoutube(String query) async {
    try {
      final results = await _yt.search.search(query);
      return results.toList();
    } catch (e, stack) {
      log('YT search failed: $e', stackTrace: stack);
      return [];
    }
  }

  Future<yt.Video?> getVideoInfo(String videoId) async {
    try {
      return await _yt.videos.get(yt.VideoId(videoId)).timeout(_requestTimeout);
    } catch (e, stack) {
      log('YT video info failed: $e', stackTrace: stack);
      return null;
    }
  }

  Future<Uri> resolveAudioUri(
    String videoId, {
    required bool forceRefresh,
  }) async {
    if (!forceRefresh && _isCacheValid(videoId)) {
      final cached = _urlCache[videoId];
      if (cached != null) return Uri.parse(cached);
    }

    _clearCache(videoId);

    final manifest = await _yt.videos.streamsClient
        .getManifest(yt.VideoId(videoId))
        .timeout(_requestTimeout);

    // Prefer audio-only streams to avoid downloading video unnecessarily.
    if (manifest.audioOnly.isNotEmpty) {
      final stream = manifest.audioOnly.withHighestBitrate();
      final uri = stream.url;

      _urlCache[videoId] = uri.toString();
      _urlCacheTime[videoId] = DateTime.now();

      log('YT audio resolved: $videoId, bitrate=${stream.bitrate}');
      return uri;
    }

    // Some videos may only expose muxed audio/video streams.
    if (manifest.muxed.isNotEmpty) {
      final stream = manifest.muxed.withHighestBitrate();
      final uri = stream.url;

      _urlCache[videoId] = uri.toString();
      _urlCacheTime[videoId] = DateTime.now();

      log('YT muxed stream resolved: $videoId');
      return uri;
    }

    // A live stream may require HLS. Handle its URL as a URI;
    // AudioSource.hls() is not available in your just_audio version.
    final liveUrl = await _yt.videos.streamsClient
        .getHttpLiveStreamUrl(yt.VideoId(videoId))
        .timeout(_requestTimeout);

    return Uri.parse(liveUrl);
  }

  Future<void> getAudioStream(
    String videoId,
    AudioPlayer player, {
    bool forceRefresh = false,
  }) async {
    if (_disposed) {
      throw StateError('YoutubeServices has already been disposed.');
    }

    Object? lastError;

    // Try a cached URL first, then retry once with a freshly resolved URL.
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        final shouldRefresh = forceRefresh || attempt > 0;

        log(
          'YT loading $videoId '
          '(attempt ${attempt + 1}, refresh=$shouldRefresh)',
        );
        final uri = await resolveAudioUri(videoId, forceRefresh: shouldRefresh);

        if (_disposed) {
          throw StateError('YoutubeServices has been disposed.');
        }

        // A .m3u8 URL can be passed as a URI. This avoids the unavailable
        // AudioSource.hls() API. Actual HLS support depends on the platform
        // and the URL returned by the stream provider.
        await player
            .setAudioSource(AudioSource.uri(uri))
            .timeout(_requestTimeout);

        // Start playback without waiting for the whole song to finish.
        unawaited(
          player.play().catchError((Object error, StackTrace stack) {
            log('YT playback error: $error', stackTrace: stack);
          }),
        );

        log('YT source loaded: $videoId');
        return;
      } catch (e, stack) {
        lastError = e;
        _clearCache(videoId);

        log(
          'YT attempt ${attempt + 1} failed for $videoId: $e',
          stackTrace: stack,
        );
      }
    }

    throw Exception('Unable to play YouTube video $videoId: $lastError');
  }

  void dispose() {
    _disposed = true;
    _urlCache.clear();
    _urlCacheTime.clear();
    _yt.close();
  }
}
