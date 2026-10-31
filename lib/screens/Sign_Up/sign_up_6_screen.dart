import 'package:flutter/material.dart';
import 'package:sf/screens/Sign_Up/sign_up_7_screen.dart';

class SignUp6Screen extends StatefulWidget {
  const new({super.key});

  @override
  State<SignUp6Screen> createState() => _SignUp6ScreenState();
}

class _SignUp6ScreenState extends State<SignUp6Screen> {
  final Set<String> selectedGenres = {};

  static const List<Map<String, dynamic>> genres = [
    {
      'name': 'Hindi',
      'color': Color(0xFFE83E32),

      'image': 'assets/images/hindi.png',
    },
    {
      'name': 'International',
      'color': Color(0xFFD98B19),
      'image': 'assets/images/international.png',
    },
    {
      'name': 'Punjabi',
      'color': Color(0xFF94218A),
      'image': 'assets/images/punjabi.png',
    },
    {
      'name': 'Tamil',
      'color': Color(0xFFE5B95C),
      'image': 'assets/images/tamil.png',
    },
    {
      'name': 'Telugu',
      'color': Color(0xFF10C782),
      'image': 'assets/images/telugu.png',
    },
    {
      'name': 'Malayalam',
      'color': Color(0xFFA3C6A8),
      'image': 'assets/images/malayalam.png',
    },
    {
      'name': 'Marathi',
      'color': Color(0xFFA86D50),
      'image': 'assets/images/marathi.png',
    },
    {
      'name': 'Gujarati',
      'color': Color(0xFFD95185),
      'image': 'assets/images/gujarati.png',
    },
    {
      'name': 'Bengali',
      'color': Color(0xFF4389D4),
      'image': 'assets/images/bengali.png',
    },
    {
      'name': 'Kannada',
      'color': Color(0xFFC8102E),
      'image': 'assets/images/kannada.png',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text(
                "What music do you like?",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  itemCount: genres.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.3,
                  ),
                  itemBuilder: (context, index) {
                    final genre = genres[index];

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Material(
                        color: genre['color'] as Color,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              final name = genre['name'] as String;

                              if (selectedGenres.contains(name)) {
                                selectedGenres.remove(name);
                              } else {
                                selectedGenres.add(name);
                              }
                            });
                          },
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: -18,
                                right: -20,
                                width: 112,
                                height: 100,
                                child: Image.asset(
                                  genre['image'] as String,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                  errorBuilder: (context, error, stack) {
                                    return const Icon(
                                      Icons.person,
                                      size: 75,
                                      color: Colors.white70,
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 10,
                                right: 2,
                                child: Text(
                                  genre['name'] as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.6,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (selectedGenres.contains(genre['name']))
                                const Positioned(
                                  top: 6,
                                  right: 6,
                                  child: CircleAvatar(
                                    radius: 13.3,
                                    backgroundColor: Colors.black,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      size: 23,
                                    ),
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
              if (selectedGenres.length != 0) ...[
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 90,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp7Screen(
                              selectedLanguages: selectedGenres.toList(),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
