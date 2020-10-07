import 'package:flutter/material.dart';
import 'package:picture_generator/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picture Generator',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}


