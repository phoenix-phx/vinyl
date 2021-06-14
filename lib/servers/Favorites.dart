import 'package:flutter/material.dart';

class Favorite{
  String name;

  Favorite(this.name);

  Map<String, dynamic> toMap(){
    return{"name": name};
  }

  Favorite.fromMap(Map<String, dynamic> map){
    name = map['name'];
  }
}