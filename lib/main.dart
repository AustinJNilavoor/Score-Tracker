import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/game_model.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(GameModelAdapter());
  Hive.registerAdapter(PlayerScoreAdapter());

  await Hive.openBox<GameModel>('games');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Score Tracker',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomePage(),
    );
  }

  // TODO: neg is not considerd in ranking and edit option and splash screen image and add player and save changes popup style
}
