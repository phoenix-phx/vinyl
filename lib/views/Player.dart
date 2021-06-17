import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:vinyl/servers/Favorites.dart';
import 'package:vinyl/servers/InfoProvider.dart';
import 'package:vinyl/servers/database.dart';

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
  bool isShuffle = false;
  bool isLooping = false;

  FavoritesDatabase db = FavoritesDatabase();
  int counter = 0;
  bool isFav = false;

  List<SongInfo> favs = [];

  @override
  void initState() {
    super.initState();
    setSong(widget.songInfo);
    //checkFav(context, widget.songInfo.title);
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

  rebuildFav(BuildContext context) async{
    //print("configurando los fav songs");
    await db.initDB();
    favs.clear();
    List<Map<String, dynamic>> favorites = await db.database.query('favs');
    for(var fav in favorites){
      //print("Unario fav: ${fav}");
      for(SongInfo song in Provider.of<InfoProvider>(context, listen: false).getFinalSongsList()){
        if(song.title == fav["name"]){
          //print("Pillao");
          favs.add(song);
          break;
        }
      }
    }
    //print("fav songs: $favs");
    //print("");
    Provider.of<InfoProvider>(context, listen: false).setFavSongs(favs);
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
          if(isLooping == false){
            player.setLoopMode(LoopMode.off);
            print('FIN');
            widget.changeTrack(context, true, isShuffle);
          }else{
            player.setLoopMode(LoopMode.one);
          }

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

  checkFav(BuildContext context, String name)async{
    db.initDB();
    List<Map<String, dynamic>> favorites = await db.database.query('favs');
    bool flag = false;
    for(var fav in favorites){
      //print("Unario: ${fav}");
      if(fav["name"] == name){
        isFav = true;
        flag = true;
        break;
      }
    }
    if(!flag){
      isFav = false;
    }
    //print("Song title: $name");
  }

  @override
  Widget build(BuildContext context) {
    var bl = Provider.of<InfoProvider>(context,listen: false).isLoop();
    var bs = Provider.of<InfoProvider>(context, listen: false).isRandom();
    //Looping(bl);
    //print('looping $bl');

    checkFav(context, widget.songInfo.title);
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
              child: Center(
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
          ),
          Center(
            child: Container(
              //margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Text(
                  widget.songInfo.artist,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 17,
                      fontWeight: FontWeight.w500
                  )
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            child: Icon(
              (isFav) ? Icons.whatshot : Icons.whatshot_outlined,
              color: (isFav) ? Colors.blue : Colors.black,
              size: 30,
            ),
            onTap: (){
              setState(() {
                if(isFav){
                  db.delete(Favorite(widget.songInfo.title));
                  print("Se borro");
                }
                else{
                  db.insert(Favorite(widget.songInfo.title));
                  print("Se agrego");
                }
                isFav = !isFav;
                rebuildFav(context);
              });
            },
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: Icon(
                        (bl) ? Icons.repeat_one: Icons.repeat,
                        color: Colors.grey,
                        size: 35,
                      ),
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        setState(() {
                          bl = !bl;
                          Provider.of<InfoProvider>(context,listen: false).setLoop(bl);
                          isLooping = bl;
                        });

                      },
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.skip_previous,
                        color: Colors.black,
                        size: 45,
                      ),
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        setState(() {
                          widget.changeTrack(context, false, isShuffle);
                        });
                      },
                    ),
                    GestureDetector(
                      child: Icon(
                        (isPlaying) ? Icons.pause_circle_filled_rounded: Icons.play_circle_fill_rounded,
                        color: Colors.black,
                        size: 65,
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
                        size: 45,
                      ),
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        setState(() {
                          widget.changeTrack(context, true, isShuffle);
                        });
                      },
                    ),
                    GestureDetector(
                      child: Icon(
                        (bs) ? Icons.shuffle : Icons.arrow_right_alt,
                        color: Colors.grey,
                        size: 35,
                      ),
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
