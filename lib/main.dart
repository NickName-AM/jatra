import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(const JatraApp());
}

/// JATRA: a living almanac of the great Newar festivals of the
/// Kathmandu Valley. Everything that moves in this app is drawn by
/// hand and driven by a controller; there is not an animation
/// package in sight.
class JatraApp extends StatelessWidget {
  const JatraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jatra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Jatra.soot,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Jatra.vermilion,
          brightness: Brightness.dark,
          surface: Jatra.soot,
        ),
        splashFactory: InkRipple.splashFactory,
      ),
      home: const HomeScreen(),
    );
  }
}
