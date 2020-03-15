import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/widgets/Logo.dart';

class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: SoftColors.blueLight,
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset('assets/Dzlogo.svg', width: 100,),
              SizedBox(height: 15,),
              Text("Загрузка...", style: TextStyle(color: SoftColors.blueDark),)
            ],
          ),
        ),
      ),
    );
  }

}