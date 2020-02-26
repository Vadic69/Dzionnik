import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school_diary/constants.dart';

class EditBells extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditBellsState();
  }
}

class EditBellsState extends State<EditBells>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          //leading: Logo(),
          iconTheme: IconThemeData(
              color: SoftColors.blueDark
          ),
          title: Text(
            "Расписание звонков",
            style: Styles.appBarTextStyle
          ),
          backgroundColor: SoftColors.blueLight,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Container(
              height: 1,
              color: SoftColors.blueDark.withOpacity(0.5),
              width: MediaQuery.of(context).size.width * 0.9,
              //margin: EdgeInsets.only(bottom: 20),
            ),
          )),
      body: Container(
        color: SoftColors.blueLight,
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20, right: 20, left: 20),
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}