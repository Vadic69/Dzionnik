import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:school_diary/MainScreen.dart';
import 'package:school_diary/constants.dart';

void main() => runApp(SchoolDiary());

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class SchoolDiary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child,
          );
        },
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
            const Locale('ru'), // English
          ],
        home: MainScreen(),
        theme: ThemeData(
          fontFamily: "Montserrat", 
          brightness: Brightness.light,
          primaryColor: Color(0xFF46B198),
          backgroundColor: Color(0xFFF1F3F6),
          disabledColor: Color(0xFFF1F3F6),
          accentColor: Color(0xFF5D78D8),
        )
    );
  }
}
