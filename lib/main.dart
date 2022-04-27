import 'package:flutter/material.dart';
import 'package:masterbank/screens/dashboard.dart';

void main() => runApp(MasterbankApp());

class MasterbankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 206, 239, 255),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.blueAccent[700],
          secondary: Colors.green[900],
          background: const Color.fromARGB(255, 206, 239, 255),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent[700],
        ),
        primaryColor: Colors.blueAccent[700],
        backgroundColor: const Color.fromARGB(255, 206, 239, 255),
      ),
      home: Dashboard(),
    );
  }
}
