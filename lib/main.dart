import 'package:flutter/material.dart';
import './my_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.pink,
        useMaterial3: true,
      ),//ThemeData
      home: const MyHomePage(),
    ); //MaterialApp
  }
}
