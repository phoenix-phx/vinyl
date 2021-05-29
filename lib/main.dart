import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:vinyl/servers/InfoProvider.dart';
import 'package:vinyl/tests/audioPlayer.dart';
import 'package:vinyl/tests/tracks.dart';
import 'package:vinyl/views/MainView.dart';
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
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: InfoProvider())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (_) => MainView()
          },
      ),
    );
  }
}