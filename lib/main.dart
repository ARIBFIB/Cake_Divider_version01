import 'package:cake_divider/screens/home_screen.dart';
import 'package:flutter/material.dart';


void main(){
  runApp(const CakeDividerApp());
}

class CakeDividerApp extends StatelessWidget {
  const CakeDividerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
