import 'package:cleanloop/pages/UserProfile/ThemeManager.dart';
import 'package:cleanloop/pages/tracking_location/location_confirmation.dart';
import 'package:cleanloop/pages/tracking_location/map_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'homePage.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeManager(),
        child: const MyApp(),
      ),
    );
  }



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CleanLoop',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeManager.themeMode,
      home:   WasteCleaningHomePage(),
    );
  }
}
