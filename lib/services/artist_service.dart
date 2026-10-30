import 'dart:convert';

import 'package:http/http.dart' as http;

class ArtistService {
  Future<List<Map<String, dynamic>>> fetchArtistNamesAndImages(
    String query,
  ) async {
    final url = Uri.https('www.theaudiodb.com', '/api/v1/json/123/search.php', {
      's': query.trim(),
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['artists'] == null) {
        return [];
      }
      final List artists = data['artists'];

      return artists.map<Map<String, dynamic>>((artist) {
        return {'name': artist['strArtist'], 'image': artist['strArtistThumb']};
      }).toList();
    } else {
      throw Exception('Failed to load artists');
    }
  }
}
