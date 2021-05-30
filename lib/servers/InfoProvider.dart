import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class InfoProvider extends ChangeNotifier{
  List<SongInfo> _songsList = [];
  int _currentIndex = 0;
  int _loaded = 0;

  Map<String, List<SongInfo>> _albumsList = Map();
  List<String> _albumsNames = [];

  Map<String, List<SongInfo>> _artistList = Map();
  List<String> _artistNames = [];


  List<SongInfo> getSongsList(){
    return _songsList;
  }

  void setSongsList(List<SongInfo> songs){
    this._songsList = songs;
    notifyListeners();
  }

  int getCurrentIndex(){
    return _currentIndex;
  }

  void setCurrentIndex(int index){
    this._currentIndex = index;
    notifyListeners();
  }

  SongInfo getMetadata(int index){
    return _songsList[index];
  }

  Map<String, List<SongInfo>> getAlbums(){
    return _albumsList;
  }

  void setAlbumsList(Map<String, List<SongInfo>> albums){
    this._albumsList = albums;
  }

  List<String> getAlbumNames(){
    return _albumsNames;
  }

  void setAlbumNames(List<String> names){
    this._albumsNames = names;
  }

  Map<String, List<SongInfo>> getArtists(){
    return _artistList;
  }

  void setArtistsList(Map<String, List<SongInfo>> artists){
    this._artistList = artists;
  }

  List<String> getArtistNames(){
    return _artistNames;
  }

  void setArtistNames(List<String> names){
    this._artistNames = names;
  }

  int isLoaded(){
    return _loaded;
  }

  void setLoadedState(){
    _loaded++;
  }
}