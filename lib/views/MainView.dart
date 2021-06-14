import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:vinyl/servers/InfoProvider.dart';
import 'package:vinyl/views/Credits.dart';
import 'package:vinyl/views/ListWidgets.dart';
import 'package:vinyl/servers/database.dart';

class MainView extends StatefulWidget {
  const MainView({Key key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin {
  // Views
  TabController _controller;

  // Provider
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];

  Map<String, List<SongInfo>> albums = Map();
  List<String> albumNames = [];
  Map<String, List<SongInfo>> artists = Map();
  List<String> artistNames = [];

  List<SongInfo> favs = [];
  FavoritesDatabase db = FavoritesDatabase();

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this, initialIndex: 1);
    getTracks();
    buildFav(context);
  }

  void getTracks() async{
    songs=await audioQuery.getSongs();
    setState(() {
      songs=songs;
    });
    Provider.of<InfoProvider>(context, listen: false).setSongsList(songs);
    Provider.of<InfoProvider>(context, listen: false).setFinalSongsList(songs);
    getAllLists(context);
  }

  buildFav(BuildContext context) async{
    print("configurando los fav songs");
    await db.initDB();
    favs.clear();
    List<Map<String, dynamic>> favorites = await db.database.query('favs');
    for(var fav in favorites){
      print("Unario fav: ${fav}");
      for(SongInfo song in Provider.of<InfoProvider>(context, listen: false).getFinalSongsList()){
        if(song.title == fav["name"]){
          print("Pillao");
          favs.add(song);
          break;
        }
      }
    }
    print("fav songs: $favs");
    print("");
    Provider.of<InfoProvider>(context, listen: false).setFavSongs(favs);
  }

  void getAllLists(BuildContext context){
    if(Provider.of<InfoProvider>(context, listen: false).isLoaded() < 2) {
      print("Ha entrao y salio pana");
      // albums
      for (var song in songs) {
        if (!albums.containsKey(song.album)) {
          albums[song.album] = [song];
          albumNames.add(song.album);
        }
        else {
          albums[song.album].add(song);
        }
      }

      // artists
      for (var song in songs) {
        if (!artists.containsKey(song.artist)) {
          artists[song.artist] = [song];
          artistNames.add(song.artist);
        }
        else {
          artists[song.artist].add(song);
        }
      }
      print(artists);
      print(albums);
      Provider.of<InfoProvider>(context, listen: false).setLoadedState();

      albumNames.sort();
      Provider.of<InfoProvider>(context, listen: false).setAlbumsList(albums);
      Provider.of<InfoProvider>(context, listen: false).setAlbumNames(albumNames);

      artistNames.sort();
      Provider.of<InfoProvider>(context, listen: false).setArtistsList(artists);
      Provider.of<InfoProvider>(context, listen: false).setArtistNames(artistNames);
    }
  }


  @override
  void dispose() {
    super.dispose();
    Provider.of<InfoProvider>(context, listen: false).getSongsList().clear();
    Provider.of<InfoProvider>(context, listen: false).getAlbums().clear();
    Provider.of<InfoProvider>(context, listen: false).getArtists().clear();
    Provider.of<InfoProvider>(context, listen: false).getAlbumNames().clear();
    Provider.of<InfoProvider>(context, listen: false).getArtistNames().clear();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light
          ),
          title: Text('Vinyl'),
          backgroundColor: Colors.black,
          elevation: 10.0,
          primary: true,
          actions: [
            /*
            IconButton(
                icon: Icon(Icons.search),
                onPressed: (){

                }
            ),
             */
            PopupMenuButton(
                itemBuilder: (ctx) => [
                  PopupMenuItem(child: Text('Credits'), value: '1',),
                ],
                onSelected: (value){
                  setState(() {
                    switch(value){
                      case '1':
                        Route route = MaterialPageRoute(builder: (context) => Credits());
                        Navigator.of(context).push(route);
                        break;
                    }
                  });
                },
            )
          ],
          bottom: TabBar(
              controller: _controller,
              tabs: [
                Tab(icon: Icon(Icons.whatshot_outlined,),),
                Tab(text: "Songs",),
                Tab(text: "Albums",),
                Tab(text: "Artists",),
              ],
          ),
        ),

        body: TabBarView(
            controller: _controller,
            children: [
              // todas las paginas a mostrar
              FavList(),
              TrackList(),
              AlbumList(),
              ArtistList(),
            ]
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
