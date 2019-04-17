import 'package:flutter/material.dart';
import 'Moment/CLMomentsPage.dart';
import './Moment/CLMomentsDetailPage.dart';
import './Moment/CLPublishMomentPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      // initialRoute: "moments",
      routes: {
        "moments": (BuildContext ctx) => CLMomentsPage(),
        "detailPage": (BuildContext ctx) => CLMomentsDetailPage(),
        "publishPage": (BuildContext ctx) => CLPublishMomentPage(),
      },
      color: Colors.white,
      home: CLMomentsPage(),
    );
  }
}
