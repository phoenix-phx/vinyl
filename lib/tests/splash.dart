import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: new BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset.bottomLeft,
                end: FractionalOffset.topRight,
                colors: [
                  // option 1
                  Colors.pink,
                  Colors.redAccent,
                  Colors.deepOrangeAccent,
                  Colors.redAccent,
                  Colors.pink,

                  /*
                  // option 2
                  Colors.indigoAccent,
                  Colors.blue,
                  Colors.blue[400],
                  Colors.blue,
                  Colors.indigoAccent,
                   */

                  /*
                  // option 3
                  Colors.lightBlue,
                  Colors.blue,
                  Colors.indigoAccent,
                  Colors.indigo,
                  Colors.deepPurple,
                 */
                ],


            )
          ),
          child: Center(
            child: Text("vinyl", style: TextStyle(fontFamily: "Arial", color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold),),
          ),
        ),
      ),
    );
  }
}
