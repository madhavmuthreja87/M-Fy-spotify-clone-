import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:sf/screens/splash_screen.dart';
import 'package:sf/services/audio_handler.dart';
import 'package:sf/providers/track_provider.dart';
import 'package:sf/screens/home_screen.dart';
import 'package:sf/screens/library_screen.dart';

import 'package:sf/screens/search_screen.dart';
import 'package:sf/screens/settings_screen.dart';
import 'package:sf/widgets/mini_player.dart';

import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox("recentSongs");
  await Hive.openBox('likedSongs');
  await Hive.openBox("playlistBox");
  await Hive.openBox("mostPlayedBox");
  await Hive.openBox("downloadedSongs");

  await Permission.notification.request();
  final handler = await AudioService.init<MyAudioHandler>(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.sf.audio',
      androidNotificationChannelName: 'Playback',
      androidNotificationOngoing: true,
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => TrackProvider(handler),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashPage(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF121212),
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
