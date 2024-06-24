// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:scouting_app/pages/home_page.dart';
import 'package:scouting_app/pages/match_page.dart';
import 'package:scouting_app/pages/settings_page.dart';
import 'package:scouting_app/pages/about_page.dart';


const Color themeColor = Color.fromARGB(255, 255, 255, 255);
const bool material3 = true;



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scouting App 2024',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
        useMaterial3: material3,
      ),
      home: const HomePage(),
    );
  }
}







