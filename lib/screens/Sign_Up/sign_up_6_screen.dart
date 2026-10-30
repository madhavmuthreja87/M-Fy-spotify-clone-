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

      'image': 'http://pnggallery.com/wp-content/uploads/arijit-singh-02.png',
    },
    {
      'name': 'International',
      'color': Color(0xFFD98B19),
      'image': 'https://freepngimg.com/thumb/justin_bieber/2-2-justin-bieber-png.png',
    },
    {
      'name': 'Punjabi',
      'color': Color(0xFF94218A),
      'image': 'https://www.vhv.rs/dpng/d/423-4235310_diljit-dosanjh-png-hd-background-diljit-dosanjh-tour.png',
    },
    {
      'name': 'Tamil',
      'color': Color(0xFFE5B95C),
      'image': 'https://p7.hiclipart.com/preview/855/558/418/allu-arjun-tollywood-film-allu-arjun-png-clipart-thumbnail.jpg',
    },
    {
      'name': 'Telugu',
      'color': Color(0xFF10C782),
      'image': 'https://media.gettyimages.com/id/2179136683/photo/sydney-australia-ar-rahman-musical-composer-and-record-producer-speaks-during-a-conference-at.jpg?s=612x612&w=0&k=20&c=CwDCdUvs3ZIIoHTRH4lew6r1fP52AHPsW6kJOVu2HBw=',
    },
    {
      'name': 'Malayalam',
      'color': Color(0xFFA3C6A8),
      'image': 'https://a10.gaanacdn.com/gn_img/artists/BZgWoQOK2d/ZgWoQJorK2/size_m.jpg',
    },
    {
      'name': 'Marathi',
      'color': Color(0xFFA86D50),
      'image': 'https://th.bing.com/th/id/OIP.3Bm9ycvtgvx5Itt7l-Ik3gHaD5?w=342&h=180&c=7&r=0&o=7&dpr=1.4&pid=1.7&rm=3',
    },
    {
      'name': 'Gujarati',
      'color': Color(0xFFD95185),
      'image': 'https://www.ajays.co.in/blog/wp-content/uploads/2024/05/Bhoomi-Trivedi.webp',
    },
    {
      'name': 'Bengali',
      'color': Color(0xFF4389D4),
      'image':
          'https://images.pexels.com/photos/7087168/pexels-photo-7087168.jpeg',
    },
    {
      'name': 'Kannada',
      'color': Color(0xFFC8102E),
      'image': 'https://th.bing.com/th/id/OIP.YNJA9tA05xa5VTMniJ8KZwHaHw?w=189&h=197&c=7&r=0&o=7&dpr=1.4&pid=1.7&rm=3',
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
                                bottom: -15,
                                right: -20,
                                width: 112,
                                height: 100,
                                child: Image.network(
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
                                  top: 8,
                                  right: 8,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.black,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      size: 20,
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
                            builder: (context) => SignUp7Screen(),
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
