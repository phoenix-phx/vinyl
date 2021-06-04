import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:vinyl/servers/InfoProvider.dart';

// ignore: must_be_immutable
class Player extends StatefulWidget {
  //const Player({Key key}) : super(key: key);
  SongInfo songInfo;
  Function changeTrack;
  final GlobalKey<PlayerStateClass> key;

  Player({this.songInfo, this.changeTrack, this.key}) : super(key: key);

  @override
  PlayerStateClass createState() => PlayerStateClass();
}

class PlayerStateClass extends State<Player> {
  double minValue = 0.0, maxValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  //bool isLooping = false;
  bool isShuffle = false;

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
      Provider.of<InfoProvider>(context, listen: false).setPlaying(isPlaying);
    });

    if(isPlaying){
      player.play();
    }
    else{
      player.pause();
    }
  }

  void Looping(bool bl) async {
    if(bl){
      await player.setLoopMode(LoopMode.one);
    }else{
      await player.setLoopMode(LoopMode.off);
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
    //isLooping = false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
        if(currentValue>=maxValue){
          print('FIN');
          widget.changeTrack(context, true, isShuffle);
        }
      });
    });
    Provider.of<InfoProvider>(context, listen: false).setCurrentSong(player);
    Provider.of<InfoProvider>(context, listen: false).setCurrentSongInfo(songInfo);
    //Provider.of<InfoProvider>(context, listen: false).setPlayerClass(this);
  }

  String getDuration(double value){
    Duration duration = Duration(milliseconds: value.round());
    return [duration.inMinutes, duration.inSeconds].map((e) => e.remainder(60).toString().padLeft(2, '0')).join(':');
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    var bl = Provider.of<InfoProvider>(context, listen: false).isLoop();
    var bs = Provider.of<InfoProvider>(context, listen: false).isRandom();
    Looping(bl);
    print('looping $bl');
    return Scaffold(
      //backgroundColor: Colors.white,
      body: Column(
        children: [
          navBar(context),
          SizedBox(height: 15,),
          Container(
            height: 210,
            width: 210,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: widget.songInfo.albumArtwork == null ?
                AssetImage('assets/music_gradient.jpg') : FileImage(File(widget.songInfo.albumArtwork,)),
                radius: 70,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                    color: Colors.black45,
                    offset: Offset(20,8),
                    spreadRadius: 3,
                    blurRadius: 25
                ),
                BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3,-4),
                    spreadRadius: -2,
                    blurRadius: 20
                ),
              ],
            ),
          ),
          SizedBox(height: 15,),
          Center(
            child: Container(
              //margin: EdgeInsets.fromLTRB(25, 10, 0, 7),
              child: Text(
                  widget.songInfo.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  )
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Text(
                  widget.songInfo.artist,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                  )
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 0, 15),
            child: Slider(
                inactiveColor: Colors.black54,
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
          ),
          Container(
            transform: Matrix4.translationValues(0, -7, 0),
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    currentTime,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500
                    )
                ),
                Text(
                    endTime,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500
                    )
                ),
              ],
            ),
          ),
          //ControlPlayer(),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: (bl) ? Controls(Icons.repeat_one): Controls(Icons.repeat),
                  onTap: (){
                    setState(() async {
                      bl = !bl;
                      Provider.of<InfoProvider>(context, listen: false).setLoop(bl);
                      if(Provider.of<InfoProvider>(context, listen: false).isLoop()){
                        print('REPETIR');
                        await player.setLoopMode(LoopMode.one);
                      }
                      else{
                        await player.setLoopMode(LoopMode.off);
                      }
                    });
                  },
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Controls(Icons.skip_previous),
                  onTap: (){
                    setState(() {
                      widget.changeTrack(context, false, isShuffle);
                    });
                  },
                ),
                GestureDetector(
                  child: (isPlaying) ? PlayControl(Icons.pause_circle_filled_rounded): PlayControl(Icons.play_circle_fill_rounded),
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    setState(() {
                      changeStatus();
                    });
                  },
                ),
                GestureDetector(
                  child: Controls(Icons.skip_next),
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    setState(() {
                      widget.changeTrack(context, true, isShuffle);
                    });
                  },
                ),
                GestureDetector(
                  child: (bs) ? Controls(Icons.shuffle) : Controls(Icons.arrow_right_alt),
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    setState(() {
                      bs = !bs;
                      Provider.of<InfoProvider>(context, listen: false).setRandom(bs);
                      print('ALEATORIO');
                      isShuffle = bs;


                      //print('random $isShuffle');
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),

    );
  }
}

Widget navBar(context){
  return Container(
    height: 90,
    margin: EdgeInsets.symmetric(horizontal: 20),
    alignment: Alignment.bottomCenter,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        NavBarItem(context,Icons.arrow_back),
        //Text('Vinyl', style: TextStyle(color: Colors.white,fontSize: 17,),),
        NavBarItem(context,Icons.list),
      ],
    ),
  );
}

// ignore: non_constant_identifier_names
Widget NavBarItem(context, IconData icon){
  return Container(
    height: 40,
    width: 40,
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black45,
              offset: Offset(5,10),
              spreadRadius: 3,
              blurRadius: 10
          ),
          BoxShadow(
              color: Colors.white,
              offset: Offset(-3,-4),
              spreadRadius: -2,
              blurRadius: 20
          ),
        ],
        color: Colors.black,borderRadius: BorderRadius.circular(10)),
    child:IconButton(
        icon: Icon(icon,color: Colors.white,),
        onPressed: (){
          if(icon==Icons.arrow_back){
            Navigator.of(context).pop();
          }
        }
    ),
  );
}


Widget PlayControl(IconData icons){
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.black,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
            color: Colors.white,
            offset: Offset(5,10),
            spreadRadius: 3,
            blurRadius: 10
        ),
        BoxShadow(
            color: Colors.black,
            offset: Offset(-3,-4),
            spreadRadius: -2,
            blurRadius: 20
        ),
      ],
    ),
    child: Stack(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(icons, size: 70,)),
          ),
        ),
      ],
    ),
  );
}

Widget Controls(IconData icons){
  return Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
            color: Colors.black45,
            offset: Offset(5,10),
            spreadRadius: 3,
            blurRadius: 10
        ),
        BoxShadow(
            color: Colors.white,
            offset: Offset(-3,-4),
            spreadRadius: -2,
            blurRadius: 20
        ),
      ],
    ),
    child: Stack(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(icons,size: 30,)),
          ),
        ),
      ],
    ),
  );
}