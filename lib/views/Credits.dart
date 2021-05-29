import 'package:flutter/material.dart';

class Credits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credits'),
        backgroundColor: Colors.redAccent,
        elevation: 10.0,
      ),
      body: Center(
          child: Text('Showing credits...')
      ),
    );
  }
}