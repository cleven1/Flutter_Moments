import 'package:flutter/material.dart';
import 'Moment/CLMomentsPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      initialRoute: "moments",
      color: Colors.white,
      home: CLMomentsPage(),
    );
  }
}
