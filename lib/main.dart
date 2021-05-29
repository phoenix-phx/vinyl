import 'package:flutter/material.dart';
import 'package:vinyl/tests/audioPlayer.dart';
import 'package:vinyl/tests/tracks.dart';
import 'package:vinyl/views/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Tracks()
    );
  }
}