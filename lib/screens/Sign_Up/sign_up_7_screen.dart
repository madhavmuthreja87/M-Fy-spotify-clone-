import 'package:flutter/material.dart';
import 'package:sf/screens/Sign_Up/sign_up_8_screen.dart';

class SignUp7Screen extends StatefulWidget {
  const new({super.key});

  @override
  State<SignUp7Screen> createState() => _SignUp7ScreenState();
}

class _SignUp7ScreenState extends State<SignUp7Screen> {
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
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SignUp8Screen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  ),
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Center(
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: 30,
                          color: const Color.fromARGB(255, 109, 109, 109),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Search",

                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 109, 109, 109),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(3),
              //   ),
              //   height: 45,
              //   width: double.infinity,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Row(
              //       children: [
              //         Icon(Icons.search, color: Colors.black, size: 30),
              //         SizedBox(width: 8),
              //         Text(
              //           "Search",
              //           style: TextStyle(
              //             color: const Color.fromARGB(185, 0, 0, 0),
              //             fontSize: 13,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
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
