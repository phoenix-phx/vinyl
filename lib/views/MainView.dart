import 'package:flutter/material.dart';
import 'package:vinyl/views/Credits.dart';

class MainView extends StatefulWidget {
  const MainView({Key key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Vinyl'),
          backgroundColor: Colors.redAccent,
          elevation: 10.0,
          primary: true,
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: (){

                }
            ),
            PopupMenuButton(
                itemBuilder: (ctx) => [
                  PopupMenuItem(child: Text('Show Splash'), value: '0',),
                  PopupMenuItem(child: Text('Credits'), value: '1',),
                ],
                onSelected: (value){
                  setState(() {
                    switch(value){
                      case '0':
                        break;
                      case '1':
                        Route route = MaterialPageRoute(builder: (context) => Credits());
                        Navigator.of(context).push(route);
                        break;
                    }
                  });
                },
            )
          ],
        ),
        body: Center(
          child: Text('wtf is happening...'),
        ),
      ),
    );
  }
}
