import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Credits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light
        ),
        title: Text('Credits'),
        backgroundColor: Colors.black,
        elevation: 10.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Vinyl', style: TextStyle(color: Colors.black, fontSize: 50),)),
          SizedBox(width: 0, height: 20,),
          Center(child: Text('Version: 1.0.0 (Beta)', style: TextStyle(color: Colors.black, fontSize: 15,),)),
          SizedBox(width: 0, height: 5,),
          Center(child: Text('Developed by: Alexander Sosa, Valeria Aguirre', style: TextStyle(color: Colors.black, fontSize: 15),)),
        ],
      )
    );
  }
}