import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:vinyl/servers/InfoProvider.dart';
import 'package:vinyl/views/Player.dart';

class TrackList extends StatefulWidget {
  const TrackList({Key key}) : super(key: key);

  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final GlobalKey<PlayerState> key = GlobalKey<PlayerState>();

  List<SongInfo> songs;
  int currentIndex;

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
    songs = Provider.of<InfoProvider>(context).getSongsList();
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
            Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(currentIndex);

            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => Player(
                      songInfo: songs[currentIndex],
                      changeTrack: (bool isNext){
                        if(isNext){
                          if(currentIndex != songs.length - 1){
                            currentIndex++;
                            Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(currentIndex);
                            //print("Current Provider Index:" + Provider.of<InfoProvider>(context, listen: false).getCurrentIndex().toString());
                          }
                        }
                        else{
                          if(currentIndex != 0){
                            currentIndex--;
                            Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(currentIndex);
                            //print("Current Provider Index:" + Provider.of<InfoProvider>(context, listen: false).getCurrentIndex().toString());
                          }
                        }
                        key.currentState.setSong(songs[currentIndex]);
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


class AlbumList extends StatefulWidget {
  const AlbumList({Key key}) : super(key: key);

  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final GlobalKey<PlayerState> key = GlobalKey<PlayerState>();

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
            /*
            currentIndex=index;
            Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(currentIndex);

            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => Player(
                      songInfo: songs[currentIndex],
                      changeTrack: (bool isNext){
                        if(isNext){
                          if(currentIndex != songs.length - 1){
                            currentIndex++;
                            Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(currentIndex);
                            //print("Current Provider Index:" + Provider.of<InfoProvider>(context, listen: false).getCurrentIndex().toString());
                          }
                        }
                        else{
                          if(currentIndex != 0){
                            currentIndex--;
                            Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(currentIndex);
                            //print("Current Provider Index:" + Provider.of<InfoProvider>(context, listen: false).getCurrentIndex().toString());
                          }
                        }
                        key.currentState.setSong(songs[currentIndex]);
                      },
                      key: key,
                    )
                )
            );

             */
          },
        ),
        separatorBuilder: (context,index)=>Divider(),
        itemCount: names.length
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
  final GlobalKey<PlayerState> key = GlobalKey<PlayerState>();

  Map<String, List<SongInfo>> artists;
  List<String> names;
  List<SongInfo> currentArtist;
  int currentIndex;

  @override
  Widget build(BuildContext context) {
    artists = Provider.of<InfoProvider>(context).getArtists();
    print("Albums en servicio: $artists");
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
          //subtitle: Text(artists[names[index]][0].artist),
          onTap: (){
            /*
            currentIndex=index;
            Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(currentIndex);

            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => Player(
                      songInfo: songs[currentIndex],
                      changeTrack: (bool isNext){
                        if(isNext){
                          if(currentIndex != songs.length - 1){
                            currentIndex++;
                            Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(currentIndex);
                            //print("Current Provider Index:" + Provider.of<InfoProvider>(context, listen: false).getCurrentIndex().toString());
                          }
                        }
                        else{
                          if(currentIndex != 0){
                            currentIndex--;
                            Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(currentIndex);
                            //print("Current Provider Index:" + Provider.of<InfoProvider>(context, listen: false).getCurrentIndex().toString());
                          }
                        }
                        key.currentState.setSong(songs[currentIndex]);
                      },
                      key: key,
                    )
                )
            );

             */
          },
        ),
        separatorBuilder: (context,index)=>Divider(),
        itemCount: names.length
    );
  }
}


