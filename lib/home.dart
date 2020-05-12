import 'package:flutter/material.dart';
import 'maps.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Spots"),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Map',
        child: Icon(Icons.map),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => MapsView())),
      ),
    );
  }
}
