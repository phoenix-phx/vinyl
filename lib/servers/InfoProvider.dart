import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vinyl/views/Player.dart';

class InfoProvider extends ChangeNotifier{
  List<SongInfo> _finalSongsList = [];
  List<SongInfo> _songsList = [];
  List<SongInfo> _favSongs = [];
  int _currentIndex = 0;
  int _loaded = 0;

  AudioPlayer _currentSong = AudioPlayer();
  SongInfo _currentSongInfo;
  SongInfo _nextSong;

  Map<String, List<SongInfo>> _albumsList = Map();
  List<String> _albumsNames = [];

  Map<String, List<SongInfo>> _artistList = Map();
  List<String> _artistNames = [];

  bool _loop = false;
  bool _random = false;
  bool _playing = false;

  IconData _controlBarIcon = Icons.play_circle_fill_rounded;
  PlayerStateClass _currentPlayerClass;

  List<SongInfo> getFinalSongsList(){
    return _finalSongsList;
  }

  void setFinalSongsList(List<SongInfo> songs){
    this._finalSongsList = songs;
    notifyListeners();
  }

  List<SongInfo> getSongsList(){
    return _songsList;
  }

  void setSongsList(List<SongInfo> songs){
    this._songsList = songs;
    notifyListeners();
  }

  List<SongInfo> getFavSongs(){
    return _favSongs;
  }

  void setFavSongs(List<SongInfo> songs){
    this._favSongs = songs;
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

  SongInfo getCurrentSongInfo(){
    return _currentSongInfo;
  }

  void setCurrentSongInfo(SongInfo song){
    this._currentSongInfo = song;
    notifyListeners();
  }

  SongInfo getNextSong(){
    return _nextSong;
  }

  void setNextSong(bool random){
    if(random){
      var rnd = Random();
      int newIndex = rnd.nextInt(_songsList.length);
      print("tama??o: ${_songsList.length}");
      print("newIndex: $newIndex");

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
    notifyListeners();
  }

  bool isRandom(){
    return _random;
  }

  void setRandom(bool newRandom){
    this._random = newRandom;
    notifyListeners();
  }

  bool isPlaying(){
    return _playing;
  }

  void setPlaying(bool newPlaying){
    this._playing = newPlaying;
    notifyListeners();
    if(newPlaying == true){
      setControlBarIcon(Icons.pause_circle_filled_rounded);
    }
    else{
      setControlBarIcon(Icons.play_circle_fill_rounded);
    }
  }

  IconData getControlBarIcon(){
    return _controlBarIcon;
  }

  void setControlBarIcon(IconData icon){
    this._controlBarIcon = icon;
    notifyListeners();
  }

  void setSong(SongInfo songInfo) async {
    await getCurrentSong().setUrl(songInfo.uri);
    setPlaying(true);
    setCurrentSongInfo(songInfo);
    notifyListeners();
  }
}