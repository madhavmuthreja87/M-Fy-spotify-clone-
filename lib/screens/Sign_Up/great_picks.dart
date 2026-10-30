import 'package:flutter/material.dart';
import 'package:sf/screens/main_navigation.dart';

class GreatPicks extends StatefulWidget {
  final List<Map<String, String>> selectedArtists;
  const GreatPicks({super.key, required this.selectedArtists});

  @override
  State<GreatPicks> createState() => _GreatPicksState();
}

class _GreatPicksState extends State<GreatPicks> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavigation()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final artists = widget.selectedArtists.take(3).toList();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 19, 19),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 125,
              width: double.infinity,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const double imageSize = 70;
                  const double overlap = 52;

                  final totalWidth =
                      imageSize + ((artists.length - 1) * overlap);

                  final startX = (constraints.maxWidth - totalWidth) / 2;

                  return Stack(
                    children: [
                      for (int i = 0; i < artists.length; i++)
                        Positioned(
                          left: startX + (i * overlap),
                          top: 20,
                          child: Container(
                            width: imageSize,
                            height: imageSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromARGB(255, 38, 38, 38),
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(artists[i]['image'] ?? ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Great picks!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
