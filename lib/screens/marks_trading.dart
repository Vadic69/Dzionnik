import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_diary/constants.dart';
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

    getUserID() async {
      userId = await AuthService().userID().toString();
    }

  @override
  Widget build(BuildContext context) {
    getUserID();
    return Scaffold(
      appBar: AppBar(
        title: Text("!!!"),
      ),
      body: Container(
        color: SoftColors.blueLight,
        child: Column(
          children: <Widget>[
            Text(userId),
            FlatButton(
              child: Text("Выйти"),
              onPressed: (){
                AuthService().logOut();
              },
            )
          ],
        )
      ),
    );
  }

}