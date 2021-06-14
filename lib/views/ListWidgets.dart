import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:vinyl/servers/Favorites.dart';
import 'package:vinyl/servers/InfoProvider.dart';
import 'package:vinyl/servers/database.dart';
import 'package:vinyl/views/Player.dart';

class TrackList extends StatefulWidget {
  const TrackList({Key key}) : super(key: key);

  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final GlobalKey<PlayerStateClass> key = GlobalKey<PlayerStateClass>();

  List<SongInfo> songs;
  int currentIndex;

  void changeTrack (BuildContext context, bool isNext, bool random){
    if(!random) {
      if (isNext) {
        if (currentIndex != songs.length - 1) {
          currentIndex++;
          Provider.of<InfoProvider>(
              context, listen: false).setCurrentIndex(
              currentIndex);
          //print("Current Provider Index:" + Provider.of<InfoProvider>(context, listen: false).getCurrentIndex().toString());
        }
      }
      else {
        if (currentIndex != 0) {
          currentIndex--;
          Provider.of<InfoProvider>(
              context, listen: false).setCurrentIndex(
              currentIndex);
          //print("Current Provider Index:" + Provider.of<InfoProvider>(context, listen: false).getCurrentIndex().toString());
        }
      }
      key.currentState.setSong(songs[currentIndex]);
      Provider.of<InfoProvider>(context, listen: false).setCurrentSong(key.currentState.player);
      Provider.of<InfoProvider>(context, listen: false).setCurrentSongInfo(songs[currentIndex]);
    }
    else{
      print("entra a la siguiente cancion");
      Provider.of<InfoProvider>(context, listen: false).setNextSong(true);
      key.currentState.setSong(Provider.of<InfoProvider>(context, listen: false).getNextSong());
      Provider.of<InfoProvider>(context, listen: false).setCurrentSong(key.currentState.player);
      Provider.of<InfoProvider>(context, listen: false).setCurrentSongInfo(songs[currentIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    songs = Provider.of<InfoProvider>(context).getFinalSongsList();
    Provider.of<InfoProvider>(context, listen: false).setSongsList(songs);
    currentIndex = Provider.of<InfoProvider>(context).getCurrentIndex();
    print("Current Provider Index (Build):" + Provider.of<InfoProvider>(context).getCurrentIndex().toString());

    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            backgroundImage: songs[index].albumArtwork == null ? AssetImage('assets/music_gradient.jpg') : FileImage(File(songs[index].albumArtwork)),
          ),
          title: Text(songs[index].title),
          subtitle: Text(songs[index].artist),
          onTap: (){
            currentIndex=index;
            // kill last song
            Provider.of<InfoProvider>(context, listen: false).getCurrentSong().stop();
            Provider.of<InfoProvider>(context, listen: false).getCurrentSong().dispose();

            Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(currentIndex);

            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => Player(
                      songInfo: songs[currentIndex],
                      changeTrack: (BuildContext context, bool isNext, bool random){
                        if(!random) {
                          if (isNext) {
                            if (currentIndex != songs.length - 1) {
                              currentIndex++;
                              Provider.of<InfoProvider>(
                                  context, listen: false).setCurrentIndex(
                                  currentIndex);
                              //print("Current Provider Index:" + Provider.of<InfoProvider>(context, listen: false).getCurrentIndex().toString());
                            }
                          }
                          else {
                            if (currentIndex != 0) {
                              currentIndex--;
                              Provider.of<InfoProvider>(
                                  context, listen: false).setCurrentIndex(
                                  currentIndex);
                              //print("Current Provider Index:" + Provider.of<InfoProvider>(context, listen: false).getCurrentIndex().toString());
                            }
                          }
                          key.currentState.setSong(songs[currentIndex]);
                          Provider.of<InfoProvider>(context, listen: false).setCurrentSong(key.currentState.player);
                          Provider.of<InfoProvider>(context, listen: false).setCurrentSongInfo(songs[currentIndex]);
                        }
                        else{
                          print("entra a la siguiente cancion");
                          Provider.of<InfoProvider>(context, listen: false).setNextSong(true);
                          key.currentState.setSong(Provider.of<InfoProvider>(context, listen: false).getNextSong());
                          Provider.of<InfoProvider>(context, listen: false).setCurrentSong(key.currentState.player);
                          Provider.of<InfoProvider>(context, listen: false).setCurrentSongInfo(songs[currentIndex]);
                        }
                      },
                      key: key,
                    )
                )
            );
          },
        ),
        separatorBuilder: (context,index)=>Divider(),
        itemCount: songs.length
    );
  }
}


class FavList extends StatefulWidget {
  const FavList({Key key}) : super(key: key);

  @override
  _FavListState createState() => _FavListState();
}

class _FavListState extends State<FavList> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final GlobalKey<PlayerStateClass> key = GlobalKey<PlayerStateClass>();

  FavoritesDatabase db = FavoritesDatabase();

  //List<SongInfo> globalSongs;
  List<SongInfo> songs;
  int currentIndex;
  int counter = 0;
  bool isEmpty = false;

  checkEmpty(){
    if(songs.length == 0){
      isEmpty = true;
    }
    else{
      isEmpty = false;
    }
  }

  /*
  buildFav(BuildContext context) async{
    await db.initDB();
    songs.clear();
    List<Map<String, dynamic>> favorites = await db.database.query('favs');
    for(var fav in favorites){
      print("Unario fav: ${fav}");
      for(SongInfo song in globalSongs){
        if(song.title == fav["name"]){
          print("Pillao");
          songs.add(song);
          break;
        }
      }
    }
    print("Songs: $songs");
    print("");
  }

   */

  @override
  Widget build(BuildContext context) {
    songs = Provider.of<InfoProvider>(context).getFavSongs();
    currentIndex = Provider.of<InfoProvider>(context).getCurrentIndex();
    print("Current Provider Index (Build):" + Provider.of<InfoProvider>(context).getCurrentIndex().toString());

    //buildFav(context);
    //Provider.of<InfoProvider>(context, listen: false).setSongsList(songs);
    // songs = Provider.of<InfoProvider>(context, listen: true).getSongsList();

    checkEmpty();
    return (isEmpty)? Center(child: Text("No favorites added"),)
        :ListView.separated(
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            backgroundImage: songs[index].albumArtwork == null ? AssetImage('assets/music_gradient.jpg') : FileImage(File(songs[index].albumArtwork)),
          ),
          title: Text(songs[index].title),
          subtitle: Text(songs[index].artist),
          onTap: (){
            currentIndex=index;
            // kill last song
            Provider.of<InfoProvider>(context, listen: false).getCurrentSong().stop();
            Provider.of<InfoProvider>(context, listen: false).getCurrentSong().dispose();

            Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(currentIndex);

            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => Player(
                      songInfo: songs[currentIndex],
                      changeTrack: (BuildContext context, bool isNext, bool random){
                        if(!random) {
                          if (isNext) {
                            if (currentIndex != songs.length - 1) {
                              currentIndex++;
                              Provider.of<InfoProvider>(
                                  context, listen: false).setCurrentIndex(
                                  currentIndex);
                              //print("Current Provider Index:" + Provider.of<InfoProvider>(context, listen: false).getCurrentIndex().toString());
                            }
                          }
                          else {
                            if (currentIndex != 0) {
                              currentIndex--;
                              Provider.of<InfoProvider>(
                                  context, listen: false).setCurrentIndex(
                                  currentIndex);
                              //print("Current Provider Index:" + Provider.of<InfoProvider>(context, listen: false).getCurrentIndex().toString());
                            }
                          }
                          key.currentState.setSong(songs[currentIndex]);
                          Provider.of<InfoProvider>(context, listen: false).setCurrentSong(key.currentState.player);
                          Provider.of<InfoProvider>(context, listen: false).setCurrentSongInfo(songs[currentIndex]);
                        }
                        else{
                          print("entra a la siguiente cancion");
                          Provider.of<InfoProvider>(context, listen: false).setNextSong(true);
                          key.currentState.setSong(Provider.of<InfoProvider>(context, listen: false).getNextSong());
                          Provider.of<InfoProvider>(context, listen: false).setCurrentSong(key.currentState.player);
                          Provider.of<InfoProvider>(context, listen: false).setCurrentSongInfo(songs[currentIndex]);
                        }
                      },
                      key: key,
                    )
                )
            );
          },
        ),
        separatorBuilder: (context,index)=>Divider(),
        itemCount: songs.length
    );
  }

  _showList(BuildContext context){
    return FutureBuilder(
        future: db.getAllFavorites(),
        builder: (BuildContext context, AsyncSnapshot<List<Favorite>> snapshot) {
          print(snapshot.data);
          print(snapshot.hasData);
          if (counter >= 1) {
            if (snapshot.data != null && snapshot.data.length > 0) {
              return ListView(
                children: [
                  for (Favorite favorite in snapshot.data) ListTile(
                    title: Text(favorite.name),)
                ],
              );
            }
            else {
              return Center(child: Text('No favorites saved'),);
            }
          }
          else {
            counter++;
            return Center(child: Text('Loading'),);
          }
        }
    );
  }
}



class AlbumList extends StatefulWidget {
  const AlbumList({Key key}) : super(key: key);

  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final GlobalKey<PlayerStateClass> key = GlobalKey<PlayerStateClass>();

  Map<String, List<SongInfo>> albums;
  List<String> names;
  List<SongInfo> currentAlbum;
  int currentIndex;

  @override
  Widget build(BuildContext context) {
    albums = Provider.of<InfoProvider>(context).getAlbums();
    print("Albums en servicio: $albums");
    names = Provider.of<InfoProvider>(context).getAlbumNames();
    print("Names: $names");

    currentIndex = Provider.of<InfoProvider>(context).getCurrentIndex();
    print("Current Provider Index (Build):" + Provider.of<InfoProvider>(context).getCurrentIndex().toString());

    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            backgroundImage: albums[names[index]][0].albumArtwork == null ? AssetImage('assets/music_gradient.jpg') : FileImage(File(albums[names[index]][0].albumArtwork)),
          ),
          title: Text(names[index]),
          subtitle: Text(albums[names[index]][0].artist),
          onTap: (){
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => AlbumSongs(albums[names[index]], names[index])
                )
            );
          },
        ),
        separatorBuilder: (context,index)=>Divider(),
        itemCount: names.length
    );
  }
}

// ignore: must_be_immutable
class AlbumSongs extends StatefulWidget {
  List<SongInfo> songs;
  String albumName;

  AlbumSongs(this.songs, this.albumName);

  @override
  _AlbumSongsState createState() => _AlbumSongsState(songs, albumName);
}

class _AlbumSongsState extends State<AlbumSongs> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final GlobalKey<PlayerStateClass> key = GlobalKey<PlayerStateClass>();

  List<SongInfo> songs;
  String albumName;
  int currentIndex;

  _AlbumSongsState(this.songs, this.albumName);

  void changeTrack(bool isNext){
    if(isNext){
      if(currentIndex != songs.length - 1){
        currentIndex++;
      }
    }
    else{
      if(currentIndex != 0){
        currentIndex--;
      }
    }
    key.currentState.setSong(songs[currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Provider.of<InfoProvider>(context, listen: false).setSongsList(songs);
    currentIndex = Provider.of<InfoProvider>(context).getCurrentIndex();
    print("Current Provider Index (Build):" + Provider.of<InfoProvider>(context).getCurrentIndex().toString());

    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light
        ),
        title: Text(albumName),
        backgroundColor: Colors.black,
        elevation: 10.0,
        primary: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (ctx) => [
              PopupMenuItem(child: Text('Credits'), value: '1',),
            ],
            onSelected: (value){
              setState(() {
                switch(value){
                  case '1':
                    /*
                    Route route = MaterialPageRoute(builder: (context) => Credits());
                    Navigator.of(context).push(route);
                     */
                    break;
                }
              });
            },
          )
        ],
      ),

      body: ListView.separated(
          itemBuilder: (context, index) => ListTile(
            leading: CircleAvatar(
              backgroundImage: songs[index].albumArtwork == null ? AssetImage('assets/music_gradient.jpg') : FileImage(File(songs[index].albumArtwork)),
            ),
            title: Text(songs[index].title),
            subtitle: Text(songs[index].artist),
            onTap: (){
              currentIndex=index;
              // kill last song
              Provider.of<InfoProvider>(context, listen: false).getCurrentSong().stop();
              Provider.of<InfoProvider>(context, listen: false).getCurrentSong().dispose();

              Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(currentIndex);

              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => Player(
                        songInfo: songs[currentIndex],
                        changeTrack: (BuildContext context, bool isNext, bool random){
                          if(!random) {
                            if (isNext) {
                              if (currentIndex != songs.length - 1) {
                                currentIndex++;
                                Provider.of<InfoProvider>(
                                    context, listen: false).setCurrentIndex(
                                    currentIndex);
                                //print("Current Provider Index:" + Provider.of<InfoProvider>(context, listen: false).getCurrentIndex().toString());
                              }
                            }
                            else {
                              if (currentIndex != 0) {
                                currentIndex--;
                                Provider.of<InfoProvider>(
                                    context, listen: false).setCurrentIndex(
                                    currentIndex);
                                //print("Current Provider Index:" + Provider.of<InfoProvider>(context, listen: false).getCurrentIndex().toString());
                              }
                            }
                            key.currentState.setSong(songs[currentIndex]);
                            Provider.of<InfoProvider>(context, listen: false).setCurrentSong(key.currentState.player);
                            Provider.of<InfoProvider>(context, listen: false).setCurrentSongInfo(songs[currentIndex]);
                          }
                          else{
                            print("entra a la siguiente cancion");
                            Provider.of<InfoProvider>(context, listen: false).setNextSong(true);
                            key.currentState.setSong(Provider.of<InfoProvider>(context, listen: false).getNextSong());
                            Provider.of<InfoProvider>(context, listen: false).setCurrentSong(key.currentState.player);
                            Provider.of<InfoProvider>(context, listen: false).setCurrentSongInfo(songs[currentIndex]);
                          }
                        },
                        key: key,
                      )
                  )
              );
            },
          ),
          separatorBuilder: (context,index)=>Divider(),
          itemCount: songs.length
      ),

        bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: (Provider.of<InfoProvider>(context, listen: false).getCurrentSongInfo() == null)
                          ? AssetImage('assets/music_gradient.jpg')
                          : (Provider.of<InfoProvider>(context, listen: false).getCurrentSongInfo().albumArtwork == null)
                          ? AssetImage('assets/music_gradient.jpg')
                          : FileImage(File(Provider.of<InfoProvider>(context, listen: false).getCurrentSongInfo().albumArtwork,)),
                    ),
                    SizedBox(width: 10, height: 0,),
                    Container(
                      width: size.width/3,
                      child: Text(
                        (Provider.of<InfoProvider>(context, listen: false).getCurrentSongInfo() == null)
                            ? 'None' : Provider.of<InfoProvider>(context, listen: false).getCurrentSongInfo().title,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                onTap: (){
                  setState(() {
                    print("I've been tapped!");
                  });
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        if(!Provider.of<InfoProvider>(context, listen: false).isRandom()) {
                          if (Provider.of<InfoProvider>(context, listen: false).getCurrentIndex() != 0) {
                            Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(Provider.of<InfoProvider>(context, listen: false).getCurrentIndex() - 1);
                          }
                          Provider.of<InfoProvider>(context, listen: false).setSong(Provider.of<InfoProvider>(context, listen: false).getSongsList()[Provider.of<InfoProvider>(context, listen: false).getCurrentIndex()]);
                        }
                        else{
                          Provider.of<InfoProvider>(context, listen: false).setNextSong(true);
                          // key.currentState.setSong(Provider.of<InfoProvider>(context, listen: false).getNextSong());
                          Provider.of<InfoProvider>(context, listen: false).setSong(Provider.of<InfoProvider>(context, listen: false).getNextSong());
                        }
                      }
                  ),
                  IconButton(
                      icon: Icon(Provider.of<InfoProvider>(context).getControlBarIcon(),
                        color: Colors.white,
                        size: 35,
                      ),
                      onPressed: (){
                        (Provider.of<InfoProvider>(context, listen: false).isPlaying())
                            ? Provider.of<InfoProvider>(context, listen: false).getCurrentSong().pause()
                            : Provider.of<InfoProvider>(context, listen: false).getCurrentSong().play();
                        Provider.of<InfoProvider>(context, listen: false).setPlaying(!Provider.of<InfoProvider>(context, listen: false).isPlaying());
                      }
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: (){
                        if(!Provider.of<InfoProvider>(context, listen: false).isRandom()) {
                          if (Provider.of<InfoProvider>(context, listen: false).getCurrentIndex() != Provider.of<InfoProvider>(context, listen: false).getSongsList().length - 1) {
                            Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(Provider.of<InfoProvider>(context, listen: false).getCurrentIndex() + 1);
                          }
                          Provider.of<InfoProvider>(context, listen: false).setSong(Provider.of<InfoProvider>(context, listen: false).getSongsList()[Provider.of<InfoProvider>(context, listen: false).getCurrentIndex()]);
                        }
                        else{
                          Provider.of<InfoProvider>(context, listen: false).setNextSong(true);
                          // key.currentState.setSong(Provider.of<InfoProvider>(context, listen: false).getNextSong());
                          Provider.of<InfoProvider>(context, listen: false).setSong(Provider.of<InfoProvider>(context, listen: false).getNextSong());
                        }
                      }
                  ),
                ],
              ),
            ],

          ),
        )
    );
  }
}



class ArtistList extends StatefulWidget {
  const ArtistList({Key key}) : super(key: key);

  @override
  _ArtistListState createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final GlobalKey<PlayerStateClass> key = GlobalKey<PlayerStateClass>();

  Map<String, List<SongInfo>> artists;
  List<String> names;
  List<SongInfo> currentArtist;
  int currentIndex;

  @override
  Widget build(BuildContext context) {
    artists = Provider.of<InfoProvider>(context).getArtists();
    print("Artists en servicio: $artists");
    names = Provider.of<InfoProvider>(context).getArtistNames();
    print("Names: $names");

    currentIndex = Provider.of<InfoProvider>(context).getCurrentIndex();
    print("Current Provider Index (Build):" + Provider.of<InfoProvider>(context).getCurrentIndex().toString());

    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            backgroundImage: artists[names[index]][0].albumArtwork == null ? AssetImage('assets/music_gradient.jpg') : FileImage(File(artists[names[index]][0].albumArtwork)),
          ),
          title: Text(names[index]),
          onTap: (){
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => AlbumSongs(artists[names[index]], names[index])
                )
            );
          },
        ),
        separatorBuilder: (context,index)=>Divider(),
        itemCount: names.length
    );
  }
}

// ignore: must_be_immutable
class ArtistSongs extends StatefulWidget {
  List<SongInfo> songs;
  String artistName;

  ArtistSongs(this.songs, this.artistName);

  @override
  _ArtistSongsState createState() => _ArtistSongsState(songs, artistName);
}

class _ArtistSongsState extends State<ArtistSongs> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final GlobalKey<PlayerStateClass> key = GlobalKey<PlayerStateClass>();

  List<SongInfo> songs;
  String artistName;
  int currentIndex;

  _ArtistSongsState(this.songs, this.artistName);

  void changeTrack(bool isNext){
    if(isNext){
      if(currentIndex != songs.length - 1){
        currentIndex++;
      }
    }
    else{
      if(currentIndex != 0){
        currentIndex--;
      }
    }
    key.currentState.setSong(songs[currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Provider.of<InfoProvider>(context, listen: false).setSongsList(songs);
    currentIndex = Provider.of<InfoProvider>(context).getCurrentIndex();
    print("Current Provider Index (Build):" + Provider.of<InfoProvider>(context).getCurrentIndex().toString());

    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light
        ),
        title: Text(artistName),
        backgroundColor: Colors.black,
        elevation: 10.0,
        primary: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (ctx) => [
              PopupMenuItem(child: Text('Credits'), value: '1',),
            ],
            onSelected: (value){
              setState(() {
                switch(value){
                  case '1':
                  /*
                    Route route = MaterialPageRoute(builder: (context) => Credits());
                    Navigator.of(context).push(route);
                     */
                    break;
                }
              });
            },
          )
        ],
      ),

      body: ListView.separated(
          itemBuilder: (context, index) => ListTile(
            leading: CircleAvatar(
              backgroundImage: songs[index].albumArtwork == null ? AssetImage('assets/music_gradient.jpg') : FileImage(File(songs[index].albumArtwork)),
            ),
            title: Text(songs[index].title),
            subtitle: Text(songs[index].artist),
            onTap: (){
              currentIndex=index;
              // kill last song
              Provider.of<InfoProvider>(context, listen: false).getCurrentSong().stop();
              Provider.of<InfoProvider>(context, listen: false).getCurrentSong().dispose();

              Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(currentIndex);

              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => Player(
                        songInfo: songs[currentIndex],
                        changeTrack: (BuildContext context, bool isNext, bool random){
                          if(!random) {
                            if (isNext) {
                              if (currentIndex != songs.length - 1) {
                                currentIndex++;
                                Provider.of<InfoProvider>(
                                    context, listen: false).setCurrentIndex(
                                    currentIndex);
                                //print("Current Provider Index:" + Provider.of<InfoProvider>(context, listen: false).getCurrentIndex().toString());
                              }
                            }
                            else {
                              if (currentIndex != 0) {
                                currentIndex--;
                                Provider.of<InfoProvider>(
                                    context, listen: false).setCurrentIndex(
                                    currentIndex);
                                //print("Current Provider Index:" + Provider.of<InfoProvider>(context, listen: false).getCurrentIndex().toString());
                              }
                            }
                            key.currentState.setSong(songs[currentIndex]);
                            Provider.of<InfoProvider>(context, listen: false).setCurrentSong(key.currentState.player);
                            Provider.of<InfoProvider>(context, listen: false).setCurrentSongInfo(songs[currentIndex]);
                          }
                          else{
                            print("entra a la siguiente cancion");
                            Provider.of<InfoProvider>(context, listen: false).setNextSong(true);
                            key.currentState.setSong(Provider.of<InfoProvider>(context, listen: false).getNextSong());
                            Provider.of<InfoProvider>(context, listen: false).setCurrentSong(key.currentState.player);
                            Provider.of<InfoProvider>(context, listen: false).setCurrentSongInfo(songs[currentIndex]);
                          }
                        },
                        key: key,
                      )
                  )
              );
            },
          ),
          separatorBuilder: (context,index)=>Divider(),
          itemCount: songs.length
      ),

        bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: (Provider.of<InfoProvider>(context, listen: false).getCurrentSongInfo() == null)
                          ? AssetImage('assets/music_gradient.jpg')
                          : (Provider.of<InfoProvider>(context, listen: false).getCurrentSongInfo().albumArtwork == null)
                          ? AssetImage('assets/music_gradient.jpg')
                          : FileImage(File(Provider.of<InfoProvider>(context, listen: false).getCurrentSongInfo().albumArtwork,)),
                    ),
                    SizedBox(width: 10, height: 0,),
                    Container(
                      width: size.width/3,
                      child: Text(
                        (Provider.of<InfoProvider>(context, listen: false).getCurrentSongInfo() == null)
                            ? 'None' : Provider.of<InfoProvider>(context, listen: false).getCurrentSongInfo().title,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                onTap: (){
                  setState(() {
                    print("I've been tapped!");
                  });
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        if(!Provider.of<InfoProvider>(context, listen: false).isRandom()) {
                          if (Provider.of<InfoProvider>(context, listen: false).getCurrentIndex() != 0) {
                            Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(Provider.of<InfoProvider>(context, listen: false).getCurrentIndex() - 1);
                          }
                          Provider.of<InfoProvider>(context, listen: false).setSong(Provider.of<InfoProvider>(context, listen: false).getSongsList()[Provider.of<InfoProvider>(context, listen: false).getCurrentIndex()]);
                        }
                        else{
                          Provider.of<InfoProvider>(context, listen: false).setNextSong(true);
                          // key.currentState.setSong(Provider.of<InfoProvider>(context, listen: false).getNextSong());
                          Provider.of<InfoProvider>(context, listen: false).setSong(Provider.of<InfoProvider>(context, listen: false).getNextSong());
                        }
                      }
                  ),
                  IconButton(
                      icon: Icon(Provider.of<InfoProvider>(context).getControlBarIcon(),
                        color: Colors.white,
                        size: 35,
                      ),
                      onPressed: (){
                        (Provider.of<InfoProvider>(context, listen: false).isPlaying())
                            ? Provider.of<InfoProvider>(context, listen: false).getCurrentSong().pause()
                            : Provider.of<InfoProvider>(context, listen: false).getCurrentSong().play();
                        Provider.of<InfoProvider>(context, listen: false).setPlaying(!Provider.of<InfoProvider>(context, listen: false).isPlaying());
                      }
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: (){
                        if(!Provider.of<InfoProvider>(context, listen: false).isRandom()) {
                          if (Provider.of<InfoProvider>(context, listen: false).getCurrentIndex() != Provider.of<InfoProvider>(context, listen: false).getSongsList().length - 1) {
                            Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(Provider.of<InfoProvider>(context, listen: false).getCurrentIndex() + 1);
                          }
                          Provider.of<InfoProvider>(context, listen: false).setSong(Provider.of<InfoProvider>(context, listen: false).getSongsList()[Provider.of<InfoProvider>(context, listen: false).getCurrentIndex()]);
                        }
                        else{
                          Provider.of<InfoProvider>(context, listen: false).setNextSong(true);
                          // key.currentState.setSong(Provider.of<InfoProvider>(context, listen: false).getNextSong());
                          Provider.of<InfoProvider>(context, listen: false).setSong(Provider.of<InfoProvider>(context, listen: false).getNextSong());
                        }
                      }
                  ),
                ],
              ),
            ],

          ),
        )
    );
  }
}

