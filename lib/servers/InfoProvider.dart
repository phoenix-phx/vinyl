import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class InfoProvider extends ChangeNotifier{
  List<SongInfo> _songsList = [];
  int _currentIndex = 0;
  int _loaded = 0;

  AudioPlayer _currentSong = AudioPlayer();
  SongInfo _nextSong;

  Map<String, List<SongInfo>> _albumsList = Map();
  List<String> _albumsNames = [];

  Map<String, List<SongInfo>> _artistList = Map();
  List<String> _artistNames = [];

  bool _loop = false;
  bool _random = false;


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
    notifyListeners();
  }

  List<String> getAlbumNames(){
    return _albumsNames;
  }

  void setAlbumNames(List<String> names){
    this._albumsNames = names;
    notifyListeners();
  }

  Map<String, List<SongInfo>> getArtists(){
    return _artistList;
  }

  void setArtistsList(Map<String, List<SongInfo>> artists){
    this._artistList = artists;
    notifyListeners();
  }

  List<String> getArtistNames(){
    return _artistNames;
  }

  void setArtistNames(List<String> names){
    this._artistNames = names;
    notifyListeners();
  }

  int isLoaded(){
    return _loaded;
  }

  void setLoadedState(){
    _loaded++;
    notifyListeners();
  }

  AudioPlayer getCurrentSong(){
    return _currentSong;
  }

  void setCurrentSong(AudioPlayer audioPlayer){
    this._currentSong = audioPlayer;
    notifyListeners();
  }

  SongInfo getNextSong(){
    return _nextSong;
  }

  void setNextSong(bool random){
    if(random){
      var rnd = Random();
      int newIndex = rnd.nextInt(_songsList.length);
      print("tamaño: ${_songsList.length}");
      print("newIndex: ${newIndex}");

      this._nextSong = _songsList[newIndex];
      this._currentIndex = newIndex;
    }
    else{
      if(_currentIndex + 1 <= _songsList.length-1) {
        this._nextSong = _songsList[_currentIndex + 1];
        this._currentIndex = _currentIndex + 1;
      }
      else{
        this._nextSong = _songsList[0];
        this._currentIndex = 0;
      }
    }
    notifyListeners();
  }

  bool isLoop(){
    return _loop;
  }

  void setLoop(bool newLoop){
    this._loop = newLoop;
  }

  bool isRandom(){
    return _random;
  }

  void setRandom(bool newRandom){
    this._random = newRandom;
  }
}