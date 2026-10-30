// import 'package:flutter/material.dart';
// import 'package:sf/screens/Sign_Up/sign_up_8_screen.dart';

// class SignUp7Screen extends StatefulWidget {
//   const new({super.key});

//   @override
//   State<SignUp7Screen> createState() => _SignUp7ScreenState();
// }

// class _SignUp7ScreenState extends State<SignUp7Screen> {
//   final Set<String> selectedArtists = {};

//   String selectedGenre = 'For You';
//   final List<String> genres = [
//     'For You',
//     'Gujarati',
//     'Marathi',
//     'Bengali',
//     'Tamil',
//     'Punjabi',
//     'Hindi',
//     'International',
//     'Telugu',
//     'Malayalam',
//     'Kannada',
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),

//           child: Column(
//             children: [
//               SizedBox(height: 5),
//               Text(
//                 "What music do you like?",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 30,
//                 ),
//               ),
//               SizedBox(height: 20),
//               GestureDetector(
//                 onTap: () => {
//                   Navigator.push(
//                     context,
//                     PageRouteBuilder(
//                       pageBuilder: (context, animation, secondaryAnimation) =>
//                           SignUp8Screen(),
//                       transitionDuration: Duration.zero,
//                       reverseTransitionDuration: Duration.zero,
//                     ),
//                   ),
//                 },
//                 child: Container(
//                   height: 44,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//                   child: Center(
//                     child: Row(
//                       children: [
//                         Icon(Icons.search, size: 28, color: Colors.black),
//                         SizedBox(width: 8),
//                         Text(
//                           "Search",

//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(height: 20),
//               SizedBox(
//                 height: 29,
//                 child: ListView.separated(
//                   padding: const EdgeInsets.symmetric(horizontal: 3),
//                   scrollDirection: Axis.horizontal,
//                   itemCount: genres.length,
//                   separatorBuilder: (_, __) => const SizedBox(width: 12),
//                   itemBuilder: (context, index) {
//                     final genre = genres[index];
//                     final isActive = selectedGenre == genre;

//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedGenre = genre;
//                         });
//                       },
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 180),
//                         padding: const EdgeInsets.symmetric(horizontal: 11),
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: isActive
//                               ? const Color(0xFF1ED760)
//                               : const Color(0xFF292929),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Text(
//                           genre,
//                           style: TextStyle(
//                             color: isActive ? Colors.black : Colors.white,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:sf/screens/Sign_Up/sign_up_8_screen.dart';

class SignUp7Screen extends StatefulWidget {
  final List<String> selectedLanguages;

  const SignUp7Screen({super.key, required this.selectedLanguages});

  @override
  State<SignUp7Screen> createState() => _SignUp7ScreenState();
}

class _SignUp7ScreenState extends State<SignUp7Screen> {
  final Set<String> selectedArtists = {};

  String selectedGenre = 'For You';
  final List<String> genres = [
    'For You',
    'Hindi',
    'Punjabi',
    'Gujarati',
    'Telugu',
    'Marathi',
    'Bengali',
    'Tamil',
    'International',
    'Malayalam',
    'Kannada',
  ];
  // Local artist data for testing.
  // Replace these URLs with verified artist image URLs.
  final Map<String, List<Map<String, String>>> artistData = {
    'Hindi': [
      {
        'name': 'Arijit Singh',
        'image': 'https://api.deezer.com/search/artist?q=Arijit+Singh&limit=1&utm_source=chatgpt.com',
      },
      {
        'name': 'Shreya Ghoshal',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Shreya',
      },
      {
        'name': 'Sonu Nigam',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Sonu',
      },
      {
        'name': 'Sunidhi Chauhan',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Sunidhi',
      },
      {
        'name': 'Badshah',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Badshah',
      },
      {
        'name': 'Honey Singh',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Honey',
      },
      {
        'name': 'Pritam',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Pritam',
      },
      {
        'name': 'Neha Kakkar',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Neha',
      },
      {
        'name': 'Anuv Jain',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Anuv',
      },
      {
        'name': 'Darshan Raval',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Darshan',
      },
      {
        'name': 'Armaan Malik',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Armaan',
      },
      {
        'name': 'King',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=King',
      },
      {
        'name': 'Jubin Nautiyal',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Jubin',
      },
      {
        'name': 'Sachet Tandon',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Sachet',
      },
      {
        'name': 'Vishal Dadlani',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Vishal',
      },
    ],

    'Punjabi': [
      {
        'name': 'Karan Aujla',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Karan',
      },
      {
        'name': 'Diljit Dosanjh',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Diljit',
      },
      {
        'name': 'AP Dhillon',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=APDhillon',
      },
      {
        'name': 'Shubh',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Shubh',
      },
      {
        'name': 'Sidhu Moose Wala',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Sidhu',
      },
      {
        'name': 'Guru Randhawa',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Guru',
      },
      {
        'name': 'B Praak',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=BPraak',
      },
      {
        'name': 'Ammy Virk',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Ammy',
      },
      {
        'name': 'Harrdy Sandhu',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Harrdy',
      },
      {
        'name': 'Jass Manak',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Jass',
      },
      {
        'name': 'Mankirt Aulakh',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Mankirt',
      },
      {
        'name': 'Parmish Verma',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Parmish',
      },
      {
        'name': 'Gurnam Bhullar',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Gurnam',
      },
      {
        'name': 'Satinder Sartaaj',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Satinder',
      },
      {
        'name': 'Arjan Dhillon',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Arjan',
      },
    ],

    'Gujarati': [
      {
        'name': 'Aditya Gadhvi',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Aditya',
      },
      {
        'name': 'Geeta Rabari',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Geeta',
      },
      {
        'name': 'Kirtidan Gadhvi',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Kirtidan',
      },
      {
        'name': 'Falguni Pathak',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Falguni',
      },
      {
        'name': 'Sachin Jigar',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=SachinJigar',
      },
      {
        'name': 'Priya Saraiya',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Priya',
      },
      {
        'name': 'Bhoomi Trivedi',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Bhoomi',
      },
      {
        'name': 'Osman Mir',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Osman',
      },
      {
        'name': 'Jignesh Barot',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Jignesh',
      },
      {
        'name': 'Kinjal Dave',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Kinjal',
      },
      {
        'name': 'Jigardan Gadhavi',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Jigardan',
      },
      {
        'name': 'Siddharth Amit Bhavsar',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Siddharth',
      },
      {
        'name': 'Manhar Udhas',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Manhar',
      },
      {
        'name': 'Aishwarya Majmudar',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Aishwarya',
      },
      {
        'name': 'Hemant Chauhan',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Hemant',
      },
    ],

    'Telugu': [
      {
        'name': 'Sid Sriram',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Sid',
      },
      {
        'name': 'Anirudh Ravichander',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Anirudh',
      },
      {
        'name': 'Devi Sri Prasad',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=DSP',
      },
      {
        'name': 'Thaman S',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Thaman',
      },
      {
        'name': 'K S Chithra',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Chithra',
      },
      {
        'name': 'Chinmayi',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Chinmayi',
      },
      {
        'name': 'Mangli',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Mangli',
      },
      {
        'name': 'Ram Miriyala',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Ram',
      },
      {
        'name': 'Rahul Sipligunj',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Rahul',
      },
      {
        'name': 'Hemachandra',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Hemachandra',
      },
      {
        'name': 'Geetha Madhuri',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Geetha',
      },
      {
        'name': 'Shankar Mahadevan',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Shankar',
      },
      {
        'name': 'S P Charan',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=SPCharan',
      },
      {
        'name': 'Karunya',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Karunya',
      },
      {
        'name': 'Sunitha Upadrasta',
        'image': 'https://api.dicebear.com/9.x/initials/png?seed=Sunitha',
      },
    ],
  };

  // List<String> get genres => [
  //   'For You',
  //   ...widget.selectedLanguages.where(
  //     (language) => artistData.containsKey(language),
  //   ),
  // ];

  List<Map<String, String>> get currentArtists {
    if (selectedGenre == 'For You') {
      final List<Map<String, String>> result = [];

      for (int i = 0; i < 15; i++) {
        for (final language in widget.selectedLanguages) {
          final artists = artistData[language] ?? [];

          if (i < artists.length &&
              !result.any((a) => a['name'] == artists[i]['name'])) {
            result.add(artists[i]);
          }

          if (result.length == 15) break;
        }

        if (result.length == 15) break;
      }

      return result;
    }

    return artistData[selectedGenre] ?? [];
  }

  void toggleArtist(String name) {
    setState(() {
      if (selectedArtists.contains(name)) {
        selectedArtists.remove(name);
      } else {
        selectedArtists.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 30,
                bottom: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),

                  const Text(
                    'What music do you like?',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 30,
                    ),
                  ),

                  // const SizedBox(height: 8),

                  // const Text(
                  //   'Choose at least 3 artists you like.',
                  //   style: TextStyle(color: Colors.grey, fontSize: 14),
                  // ),
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                          ) => SignUp8Screen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Row(
                        children: [
                          Icon(Icons.search, size: 28, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            'Search',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

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
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF1ED760)
                                  : const Color.fromARGB(255, 75, 74, 74),
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

                  const SizedBox(height: 20),

                  Expanded(
                    child: GridView.builder(
                      itemCount: currentArtists.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.78,
                          ),
                      itemBuilder: (context, index) {
                        final artist = currentArtists[index];
                        final name = artist['name']!;
                        final image = artist['image']!;
                        final isSelected = selectedArtists.contains(name);

                        return GestureDetector(
                          onTap: () => toggleArtist(name),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        // color: isSelected
                                        //     ? const Color(0xFF1ED760)
                                        //     : Colors.transparent,
                                        width: 3,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) {
                                          return Container(
                                            color: Colors.grey.shade800,
                                            child: const Icon(
                                              Icons.person,
                                              color: Colors.white,
                                              size: 45,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  if (isSelected)
                                    const Positioned(
                                      right: 0,
                                      top: 0,
                                      child: CircleAvatar(
                                        radius: 17,
                                        backgroundColor: Colors.black,
                                        child: Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          size: 31,
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Text(
                                name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 48,
                  //   child: ElevatedButton(
                  //     onPressed: selectedArtists.length >= 3
                  //         ? () {
                  //             debugPrint('Selected artists: $selectedArtists');
                  //             // Navigate to your next signup screen here.
                  //           }
                  //         : null,
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: const Color(0xFF1ED760),
                  //       disabledBackgroundColor: Colors.grey.shade800,
                  //       foregroundColor: Colors.black,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(30),
                  //       ),
                  //     ),
                  //     child: Text(
                  //       'Continue (${selectedArtists.length}/3)',
                  //       style: const TextStyle(fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            if (selectedArtists.length >= 3)
              Positioned(
                bottom: 22,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp8Screen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 18,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
