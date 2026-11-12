import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sf/services/audis_api.dart';
import 'package:sf/providers/track_provider.dart';
import 'package:sf/screens/recents_screen.dart';
import 'package:sf/models/track_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrackProvider>().fetchLatestSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<TrackProvider>();
    final latestSongs = tracker.LatestSongs();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        child: Text("M"),
                        backgroundColor: Colors.orange,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Search",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            Icon(
                              Icons.camera_enhance_outlined,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                          ) => RecentsScreen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      ),
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 25,
                            color: const Color.fromARGB(255, 109, 109, 109),
                          ),
                          Text(
                            "What do you want to listen to?",

                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 109, 109, 109),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,

                    crossAxisCount: 2,
                    childAspectRatio: 2.6,
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.pink,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            left: 4,
                            child: Text(
                              "Music",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Positioned(
                            right: -17,
                            bottom: -17,
                            child: Image.asset(
                              'assets/images/p1.png',
                              width: 105,
                              height: 75,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromARGB(255, 1, 97, 5),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            left: 4,
                            child: Text(
                              "Podcasts",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Positioned(
                            right: -24,
                            bottom: -20,
                            child: Image.asset(
                              'assets/images/p2.png',
                              width: 105,
                              height: 75,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromARGB(255, 207, 105, 224),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            left: 4,
                            child: Text(
                              "Live\nEvents",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Positioned(
                            right: -20,
                            bottom: -20,
                            child: Image.asset(
                              'assets/images/p3.png',
                              width: 105,
                              height: 75,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromARGB(255, 33, 91, 191),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            left: 4,
                            child: Text(
                              "Home of\nI-Pop",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Positioned(
                            right: -24,
                            bottom: -20,
                            child: Image.asset(
                              'assets/images/p4.png',
                              width: 105,
                              height: 75,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Discover something new",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 3.8,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: latestSongs.length,
                      itemBuilder: (context, index) {
                        final element = latestSongs[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 15, top: 6),
                          child: GestureDetector(
                            onTap: () {
                              context.read<TrackProvider>().setSongAndPlay(
                                element,
                                // TrackModel(
                                //   id: element['id'] ?? "",
                                //   title: element['title'] ?? "",
                                //   artist: element['artist'] ?? "",
                                //   duration: element['duration'] ?? "",
                                //   isStreamable: element['isStreamable'] ?? "",
                                //   artwork: element['artwork'] ?? "",
                                //   streamUrl: element['streamUrl'] ?? "",
                                // ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                              ),
                              height: MediaQuery.sizeOf(context).height / 3.8,
                              width: MediaQuery.sizeOf(context).width / 2.5,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      8,
                                    ),
                                    // child: Image.network(
                                    //   element['artwork'],
                                    //   fit: BoxFit.cover,
                                    // ),
                                    child: Container(
                                      color: const Color.fromARGB(
                                        225,
                                        160,
                                        160,
                                        160,
                                      ),
                                      height: 150,
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: element.artwork!,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                              child: Icon(
                                                Icons.music_note,
                                                color: Colors.white,
                                                size: 44,
                                              ),
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Song",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    element.title,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
