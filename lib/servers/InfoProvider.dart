import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class InfoProvider extends ChangeNotifier{
  List<SongInfo> _songsList = [];
  int _currentIndex = 0;

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
}