import 'package:flutter/material.dart';
import 'package:timezone/data/latest_10y.dart';
import 'pages/homepage.dart';
import 'package:timezone/timezone.dart';

void main() {
  initializeTimeZones();
  setLocalLocation(getLocation('Asia/Tokyo'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
