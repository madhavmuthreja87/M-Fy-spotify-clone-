import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sf/services/artist_service.dart';

class SignUp8Screen extends StatefulWidget {
  const SignUp8Screen({super.key});

  @override
  State<SignUp8Screen> createState() => _SignUp8ScreenState();
}

class _SignUp8ScreenState extends State<SignUp8Screen> {
  final TextEditingController artistController = TextEditingController();

  final ArtistService artistService = ArtistService();

  List<Map<String, dynamic>> artistResults = [];

  bool isSearching = false;

  Future<void> searchArtists(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        artistResults = [];
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    try {
      final results = await artistService.fetchArtistNamesAndImages(query);

      if (!mounted) return;

      setState(() {
        artistResults = results;
        isSearching = false;
      });

      log('Artist results: $results');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSearching = false;
        artistResults = [];
      });

      log('Artist Search Error: $e');
    }
  }

  @override
  void dispose() {
    artistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        backgroundColor: const Color.fromARGB(36, 247, 247, 247),

        title: Padding(
          padding: const EdgeInsets.only(right: 18),
          child: SizedBox(
            height: 39,
            child: TextField(
              controller: artistController,
              cursorColor: Colors.green,
              autofocus: true,
              textInputAction: TextInputAction.search,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),

              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                hintText: 'Search artist...',
                hintStyle: const TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(176, 224, 224, 224),
                ),
                fillColor: const Color.fromARGB(108, 106, 105, 105),
              ),

              onChanged: searchArtists,
            ),
          ),
        ),
      ),

      body: isSearching
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : artistResults.isEmpty
          ? const Center(
              child: Text(
                'Search your favourite artist',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
            )
          : ListView.builder(
              itemCount: artistResults.length,
              itemBuilder: (context, index) {
                final artist = artistResults[index];

                return ListTile(
                  contentPadding: EdgeInsets.all(9),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: artist['image'] != null
                        ? NetworkImage(artist['image'])
                        : null,
                    child: artist['image'] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),

                  title: Text(
                    artist['name'] ?? 'Unknown Artist',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  onTap: () {
                    debugPrint('Selected: ${artist['name']}');
                  },
                );
              },
            ),
    );
  }
}
