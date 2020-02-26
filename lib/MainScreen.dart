import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school_diary/screens/timetable.dart';
import 'package:school_diary/screens/subjects_list.dart';
import 'package:school_diary/constants.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

List<Widget> screens = [
  SubjectsList(),
  Timetable()
];

List<String> AppBarNames = [
  "Предметы",
  "Расписание"
];

int currentPage = 1;

class MainScreenState extends State<MainScreen> {

  Widget BottomItem (Widget child, int index){
    return GestureDetector(
      onTap: (){
        currentPage = index;
        setState((){});
      },
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
            //color: SoftColors.blueLight,
            color: index==currentPage ? Colors.transparent : SoftColors.blueLight,
            boxShadow: index==currentPage ? PressedShadow.shadow : UnpressedShadow.shadow,
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Center(child: child)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: SoftColors.blueLight,
        elevation: 0,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              BottomItem(Text('7,3', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SoftColors.blueDark),), 0),
              BottomItem(Icon(Icons.timer, color: SoftColors.blueDark,), 1),
            ],
          ),
          height: 80,
          decoration: BoxDecoration(
              color: SoftColors.blueLight,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0,-5),
                    color: SoftColors.blueLight,
                    spreadRadius: 8,
                    blurRadius: 10
                )
              ]
          ),
        ),
      ),
      body: screens[currentPage],
    );
  }

}