import 'package:flutter/material.dart';

class SignUp6Screen extends StatefulWidget {
  const new({super.key});

  @override
  State<SignUp6Screen> createState() => _SignUp6ScreenState();
}

class _SignUp6ScreenState extends State<SignUp6Screen> {
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
      'image': 'https://www.alamy.com/nov-16-2012-new-delhi-new-delhi-india-leading-indian-indian-playback-singer-k-hariharan-performing-at-qutub-festival-in-new-delhi-hariharan-has-sung-for-tamil-hindi-malayalam-kannada-marathi-bhojpuri-and-telugu-films-he-is-also-an-established-ghazal-singer-and-one-of-the-pioneers-of-indian-fusion-music-credit-image-ankit-agrawalzumapresscom-image658822545.html?imageid=94C2540C-BFC4-4FB5-AB8D-55956EB47E7C&pn=1&searchId=56c3db34c3e0e82448cc7ff4bd24b7b3&searchtype=0',
    },
    {
      'name': 'Gujarati',
      'color': Color(0xFFD95185),
      'image':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300',
    },
    {
      'name': 'Bengali',
      'color': Color(0xFF4389D4),
      'image':
          'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=300',
    },
    {
      'name': 'Kannada',
      'color': Color(0xFFC8102E),
      'image':
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300',
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
                            debugPrint('Selected ${genre['name']}');
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
    );
  }
}
