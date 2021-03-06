//TODO: warning!! this sample uses -> just_audio: ^0.4.4

import 'dart:io';

//import 'package:audioplayers/audio_cache.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

// ignore: must_be_immutable
class MusicPlayer extends StatefulWidget {
  //const MusicPlayer({Key key}) : super(key: key);
  SongInfo songInfo;
  Function changeTrack;
  final GlobalKey<MusicPlayerState> key;

  MusicPlayer({this.songInfo, this.changeTrack, this.key}) : super(key: key);

  @override
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  double minValue = 0.0, maxValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    setSong(widget.songInfo);
  }

  void dispose(){
    super.dispose();
    // ignore: unnecessary_statements
    player?.dispose;
  }

  void changeStatus(){
    setState(() {
      isPlaying = !isPlaying;
    });

    if(isPlaying){
      player.play();
    }
    else{
      player.pause();
    }
  }

  void setSong(SongInfo songInfo) async {
    widget.songInfo = songInfo;
    await player.setUrl(widget.songInfo.uri);

    currentValue = minValue;
    print("Current value: $currentValue");
    maxValue = player.duration.inMilliseconds.toDouble();
    /*
    player.durationHandler = (p) => setState((){
      maxValue = p.inMilliseconds as double;
    });
     */

    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maxValue);
    });
    print("End Time: $endTime");

    isPlaying = false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
      });
    });
    /*
    player.onAudioPositionChanged.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
      });
    });
     */
  }

  String getDuration(double value){
    Duration duration = Duration(milliseconds: value.round());
    return [duration.inMinutes, duration.inSeconds].map((e) => e.remainder(60).toString().padLeft(2, '0')).join(':');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black,),
              onPressed: (){
                Navigator.of(context).pop();
              }
          ),
          title: Text('Music Player', style: TextStyle(color: Colors.black),),
        ),

        body: Container(
          margin: EdgeInsets.fromLTRB(5, 40, 5, 0),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: widget.songInfo.albumArtwork == null ? AssetImage('assets/music_gradient.jpg') : FileImage(File(widget.songInfo.albumArtwork)),
                radius: 95,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 7),
                child: Text(
                    widget.songInfo.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Text(
                    widget.songInfo.artist,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500
                    )
                ),
              ),
              Slider(
                  inactiveColor: Colors.black12,
                  activeColor: Colors.black,
                  min: minValue,
                  max: maxValue,
                  value: currentValue,
                  onChanged: (value){
                    setState(() {
                      currentValue = value;
                      player.seek(Duration(milliseconds: currentValue.round()));
                    });
                  }
              ),
              Container(
                transform: Matrix4.translationValues(0, -7, 0),
                margin: EdgeInsets.fromLTRB(5, 0, 5, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        currentTime,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500
                        )
                    ),
                    Text(
                        endTime,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500
                        )
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.skip_previous,
                        color: Colors.black,
                        size: 55,
                      ),
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        setState(() {
                          widget.changeTrack(false);
                        });
                      },
                    ),
                    GestureDetector(
                      child: Icon(
                        (isPlaying) ? Icons.pause_circle_filled_rounded: Icons.play_circle_fill_rounded,
                        color: Colors.black,
                        size: 75,
                      ),
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        setState(() {
                          changeStatus();
                        });
                      },
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.skip_next,
                        color: Colors.black,
                        size: 55,
                      ),
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        setState(() {
                          widget.changeTrack(true);
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
