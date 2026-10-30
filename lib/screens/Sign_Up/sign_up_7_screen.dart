import 'package:flutter/material.dart';

class SignUp7Screen extends StatefulWidget {
  const new({super.key});

  @override
  State<SignUp7Screen> createState() => _SignUp7ScreenState();
}

class _SignUp7ScreenState extends State<SignUp7Screen> {
  TextEditingController artistController = TextEditingController();

  final Set<String> selectedArtists = {};

  String selectedGenre = 'For You';
  final List<String> genres = [
    'For You',
    'Gujarati',
    'Marathi',
    'Bengali',
    'Tamil',
    'Punjabi',
    'Hindi',
    'International',
    'Telugu',
    'Malayalam',
    'Kannada',
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),

          child: Column(
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
                height: 45,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.black, size: 30),
                      SizedBox(width: 8),
                      Text(
                        "Search",
                        style: TextStyle(
                          color: const Color.fromARGB(185, 0, 0, 0),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 29,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  scrollDirection: Axis.horizontal,
                  itemCount: genres.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final genre = genres[index];
                    final isActive = selectedGenre == genre;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGenre = genre;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 11),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF1ED760)
                              : const Color(0xFF292929),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          genre,
                          style: TextStyle(
                            color: isActive ? Colors.black : Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
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
    );
  }
}
