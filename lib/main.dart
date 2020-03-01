import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:school_diary/MainScreen.dart';

void main() => runApp(SchoolDiary());

class SchoolDiary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
        theme: ThemeData(fontFamily: "Montserrat"));
  }
}
