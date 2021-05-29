import 'package:flutter/material.dart';
import 'package:vinyl/views/Credits.dart';

class MainView extends StatefulWidget {
  const MainView({Key key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this, initialIndex: 0);
  }

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
              Center(child: Text('Songs List'),),
              Center(child: Text('Albums List'),),
              Center(child: Text('Artists List'),),

            ]
        ),
      ),
    );
  }
}
