import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/splash.dart';
import 'lists.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Userlists(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
