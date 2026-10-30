import 'dart:convert';

import 'package:http/http.dart' as http;

class ArtistService {
  Future<List<Map<String, dynamic>>> fetchArtistNamesAndImages(
    String query,
  ) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.https('api.deezer.com', '/search/artist', {
      'q': query.trim(),
      'limit': '20',
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List artists = data['data'] ?? [];

      return artists.map<Map<String, dynamic>>((artist) {
        return {'name': artist['name'], 'image': artist['picture_medium']};
      }).toList();
    }

    throw Exception('Failed to load artists');
  }
}
