import 'dart:convert';

import 'package:http/http.dart' as http;

class ArtistService {
  Future<List<String>> fetchArtistNames(String query) async {
    final url = Uri.https('musicbrainz.org', '/ws/2/artist/', {
      'query': 'artist:"$query"',
      'fmt': 'json',
      'limit': '20',
    });

    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'MFyMusicApp/1.0.0 (contact: your-email@example.com)',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final artists = data['artists'] as List;

      return artists.map((artist) => artist['name'] as String).toSet().toList();
    } else {
      throw Exception('Failed to load artists');
    }
  }
}
