import 'package:flutter/material.dart';
import 'package:sqlite_app_challenge/widgets/home_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeController(title: 'Flutter Sqlite'),
      debugShowCheckedModeBanner: false,
    );
  }
}

