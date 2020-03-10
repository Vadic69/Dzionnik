import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/screens/classroom.dart';
import 'package:school_diary/screens/known_hometask.dart';
import 'package:school_diary/screens/unknown_hometask.dart';
import 'package:school_diary/services/auth_service.dart';

class MarksTrading extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MarksTradingState();
  }

}

class MarksTradingState extends State<MarksTrading>{
  String userId;

    Future getUserID() async {
      userId = await AuthService().userID().toString();
    }

  @override
  Widget build(BuildContext context) {
    getUserID();
    return DefaultTabController(
        length: 3,

          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              //leading: Logo(),
              leading: Container(
                child: SvgPicture.asset('assets/Dzlogo.svg'),
                padding: EdgeInsets.all(10),
              ),
              title: Text(
                "Домашнее задание",
                style: Styles.appBarTextStyle
              ),
              backgroundColor: SoftColors.blueLight,
              elevation: 0,
              bottom: TabBar(
                indicatorColor: SoftColors.blueDark,
                tabs: [
                  Tab(child: Text("Известное", style: TextStyle(color: Colors.black),),),
                  Tab(child: Text("Запросы", style: TextStyle(color: Colors.black)), ),
                  Tab(child: Text("Класс", style: TextStyle(color: Colors.black)), ),
                ]
              )
              
              ),
            body: TabBarView(
              children: <Widget>[
                KnownHometaskPage(),
                UnknownHometaskPage(),
                ClassroomPage()
              ],
            )
          ),
    );
  }

}