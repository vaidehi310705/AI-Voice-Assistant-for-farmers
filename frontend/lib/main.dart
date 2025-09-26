import 'package:flutter/material.dart';
import 'package:frontend/screens/dashboard.dart'; // Import your dashboard file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // remove debug banner
      title: 'Dashboard Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),


    );
  }
}
