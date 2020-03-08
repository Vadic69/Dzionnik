import 'package:flutter/material.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/widgets/Logo.dart';

class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: SoftColors.blueLight,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          children: <Widget>[
            Logo(),
            Text("Загрузка")
          ],
        ),
      ),
    );
  }

}