import 'package:flutter/material.dart';
import 'package:travo_app/screens/app_screens.dart';

class TravoApp extends StatelessWidget {
  const TravoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
    );
  }
}
