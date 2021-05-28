
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

// ignore: must_be_immutable
class MusicPlayer extends StatefulWidget {
  //const MusicPlayer({Key key}) : super(key: key);
  SongInfo songInfo;

  MusicPlayer({SongInfo this.songInfo});

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  double minValue=0.0, maxValuer=0.0, currentValue=0.0;
  String currentTime='',endTime='';
  //final AudioPlayer player=AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor: Colors.black,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: (){
              Navigator.of(context).pop();
            }
        ),
          title: Text('Player', style: TextStyle(color: Colors.white),),
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(5, 40, 5, 0),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: widget.songInfo.albumArtwork==null?
                AssetImage('assets/images/music_gradient.jpg'):
                FileImage(File(widget.songInfo.albumArtwork)),radius: 95,),
              Container(margin: EdgeInsets.fromLTRB(0, 10, 0, 7),
                child: Text(widget.songInfo.title,
                    style: TextStyle(color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
              Container(margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Text(widget.songInfo.artist,
                    style: TextStyle(color: Colors.grey,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500)),
              ),
              Slider(
                  inactiveColor: Colors.black12,
                  activeColor: Colors.black,
                  //value: value, onChanged: onChanged
              )

            ],
          ),
        ),
      ),
    );
  }
}
