import 'package:flutter/material.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<InfoProvider>(context, listen: false).setSongsList(songs);
    //Provider.of<InfoProvider>(context, listen: false).setCurrentIndex(currentIndex);

    return Scaffold(
        appBar: AppBar(
          title: Text('Vinyl --- ' + Provider.of<InfoProvider>(context).getCurrentIndex().toString()),
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
              Center(child: Text('Albums List'),),
              Center(child: Text('Artists List'),),
            ]
        ),
    );
  }
}
