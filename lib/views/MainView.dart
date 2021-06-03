import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:vinyl/servers/InfoProvider.dart';
import 'package:vinyl/views/Credits.dart';
import 'package:vinyl/views/ListWidgets.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this, initialIndex: 0);
    getTracks();
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
    /*
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      // statusBarColor: Colors.white,
      // iOS
      statusBarBrightness: Brightness.dark,

      // android
      statusBarIconBrightness: Brightness.light,

    ));

     */
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
              TrackList(),
              AlbumList(),
              ArtistList(),
            ]
        ),
    );
  }
}
