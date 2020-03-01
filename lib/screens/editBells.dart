import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:school_diary/constants.dart';

class EditBells extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditBellsState();
  }
}

class EditBellsState extends State<EditBells>{

  Future<Null> selectTime(BuildContext context, int order, bool b) async {

    DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      locale: LocaleType.ru,
      showSecondsColumn: false,
      onConfirm: (time){
        print(time.minute);
      }
    );

  }

  List<Widget> buildList(){

    double margin, width, height, screenWidth;
    screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);
    margin = 20;
    width = ((screenWidth-4*margin)/2)-1;
    print(width);

    List<Widget> ret = List<Widget>();
    for (int i=0; i<8; i++)
      ret.add(Container(
        decoration: BoxDecoration(
          boxShadow: UnpressedShadow.shadow,
          color: SoftColors.blueLight,
          borderRadius: BorderRadius.circular(30)
        ),
        margin: EdgeInsets.all(margin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: width/2,
              height: width,
              alignment: Alignment(0.0,0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text((i+1).toString(), style: TextStyle(fontSize: 30),),
                  Text("Урок")
                ],
              ),
            ),
            Container(
              color: SoftColors.blueDark.withOpacity(0.2),
              width: 1,
              height: width,
            ),
            Column(
              children: <Widget>[
                Container(
                  width: width/2,
                  height: width/2,
                  child: FlatButton(
                    onPressed: () {
                      print("111");
                    },
                    child: Container(
                      child: Text("8:00", style: TextStyle(color: SoftColors.blueDark, fontSize: 18)),
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  width: width/2,
                  color: SoftColors.blueDark.withOpacity(0.2),
                ),
                Container(
                  width: width/2,
                  height: width/2,
                  child: FlatButton(
                    onPressed: () {
                      selectTime(context, i);
                    },
                    child: Container(
                      child: Text("8:45", style: TextStyle(color: SoftColors.blueDark, fontSize: 18)),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
    ));

    return ret;
  }

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
            ),
          )),
      body: Container(
        color: SoftColors.blueLight,
        child: GridView.count(crossAxisCount: 2,
          children: buildList(),
        ),
      )
      );
  }

}