import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(Spotter());
}

class Spotter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Spotter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.grey[900],
          accentColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage());
  }
}
