//TODO: warning!! this sample uses -> audioplayers: ^0.8.0

/*
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SimpleAudioPlayer extends StatefulWidget {
  const SimpleAudioPlayer({Key key}) : super(key: key);

  @override
  _SimpleAudioPlayerState createState() => _SimpleAudioPlayerState();
}

class _SimpleAudioPlayerState extends State<SimpleAudioPlayer> {
  final audioName = "queganas.mp3";

  AudioPlayer audioPlayer;
  AudioCache audioCache;

  double volume = 1;
  bool paused = false;

  Duration duration = Duration();
  Duration position = Duration();

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);

    audioPlayer.positionHandler = (p) => setState((){
      position = p;
    });
    audioPlayer.durationHandler = (p) => setState((){
      duration = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: Text("Music Player"), centerTitle: true,),
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createIconButton(Icons.volume_down, Colors.amber[200], () {
                        if (volume > 0){
                          volume -= 0.1;
                          audioPlayer.setVolume(volume);
                        }
                      }),
                      createIconButton(Icons.multitrack_audio, Colors.pink, () {
                        if (!paused)
                          audioCache.play(audioName);
                        else {
                          audioPlayer.resume();
                          paused = false;
                        }
                      }),
                      createIconButton(Icons.pause, Colors.red[300], () {
                        if (!paused) {
                          audioPlayer.pause();
                          paused = true;
                        }
                      }),
                      createIconButton(Icons.stop, Colors.black, () {audioPlayer.stop();}),
                      createIconButton(Icons.volume_up, Colors.amber[700], () {
                        if (volume < 1){
                          volume += 0.1;
                          audioPlayer.setVolume(volume);
                        }
                      }),
                    ],
                  ),
                  Slider(
                      value: position.inSeconds.toDouble(),
                      max: duration.inSeconds.toDouble(),
                      onChanged: (double seconds){
                        setState(() {
                          audioPlayer.seek(Duration(seconds: seconds.toInt()));
                        });
                      }
                  ),
                ],
              )
          ),
        )
    );
  }

  Widget createIconButton(IconData icon, Color color, VoidCallback onPressed){
    return IconButton(
        icon: Icon(icon),
        iconSize: 60,
        color: color,
        onPressed: onPressed
    );
  }
}
*/