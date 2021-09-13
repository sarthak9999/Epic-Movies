import 'package:flutter/material.dart';
import 'package:movies_app/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Epic Movies',
      debugShowCheckedModeBanner:false,
      theme: ThemeData(
        fontFamily: 'cv',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}
