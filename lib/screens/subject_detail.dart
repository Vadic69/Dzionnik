import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_diary/models/subject.dart';
import 'package:school_diary/models/mark.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/services/database_helper.dart';
import 'package:school_diary/widgets/Mark_card.dart';
import 'package:sqflite/sqflite.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MarksList extends StatefulWidget {
  final Subject subject;

  MarksList(this.subject);

  @override
  State<StatefulWidget> createState() {
    return MarksListState(this.subject);
  }
}

class MarksListState extends State<MarksList> {
  List<Mark> marksList;
  Subject subject;

  MarksListState(this.subject);

  Mark selectedMark = Mark(value: 5);

  DatabaseHelper databaseHelper = DatabaseHelper();

  void saveData() async {
    int result;
    result = await databaseHelper.insertMark(selectedMark);
    if (result != 0) {
      subject.marksKol++;
      updateSubject();
      //print("Success!");
    } else {
      //print("ERROR!");
    }
    Navigator.pop(context, true);
  }

  void updateSubject() async {
    if (subject.marksKol>0){
      int sum = await databaseHelper.getMarksSum(subject);
      subject.averageMark = (sum / subject.marksKol);
      subject.averageMark = subject.averageMark * 10;
      subject.averageMark = subject.averageMark.floorToDouble();
      subject.averageMark = subject.averageMark / 10;
    } else {
      subject.averageMark = 0.0;
    }
    //print(subject.averageMark);
    databaseHelper.updateSubject(subject);
  }

  void updateMarksList() {
    final Future<Database> dbFuture = databaseHelper.inicializeDatabase();
    dbFuture.then((database) {
      Future<List<Mark>> marksListFuture = databaseHelper.getMarksList(subject);
      marksListFuture.then((marksList) {
        setState(() {
          this.marksList = marksList;
        });
      });
    });
  }

  void showAddDialog() {
    Alert(
        style: SoftStyles.alertStyle,
        title: subject.name,
        desc: "Добавить отметку",
        context: context,
        content: Column(
          children: <Widget>[
            Container(
                child: Icon(Icons.arrow_drop_up),
                margin: EdgeInsets.only(top: 20)),
            Container(
              height: 70,
              width: 80,
              child: PageView(
                children: <Widget>[
                  MarkCard(value: "1", fontSize: 40),
                  MarkCard(value: "2", fontSize: 40),
                  MarkCard(value: "3", fontSize: 40),
                  MarkCard(value: "4", fontSize: 40),
                  MarkCard(value: "5", fontSize: 40),
                  MarkCard(value: "6", fontSize: 40),
                  MarkCard(value: "7", fontSize: 40),
                  MarkCard(value: "8", fontSize: 40),
                  MarkCard(value: "9", fontSize: 40),
                  MarkCard(value: "10", fontSize: 40),
                ],
                onPageChanged: (index) {
                  selectedMark.value = index + 1;
                  //print(selectedMark.value);
                },
                scrollDirection: Axis.vertical,
              ),
            ),
            Container(
              child: Icon(Icons.arrow_drop_down),
              margin: EdgeInsets.only(bottom: 20),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 15, top: 15),
                decoration: BoxDecoration(boxShadow: UnpressedShadow.shadow),
                child: DialogButton(
                  height: 45,
                  child: Text("Добавить",
                      style:
                          TextStyle(color: SoftColors.blueLight, fontSize: 20)),
                  radius: BorderRadius.circular(15),
                  color: SoftColors.blueDark,
                  //textColor: Colors.white,
                  onPressed: () {
                    saveData();
                    //Navigator.of(context).pop();
                    updateMarksList();
                  },
                )),
            Container(
              decoration: BoxDecoration(boxShadow: UnpressedShadow.shadow),
              child: DialogButton(
                height: 45,
                child: Text("Отмена",
                    style: TextStyle(color: SoftColors.blueDark, fontSize: 20)),
                radius: BorderRadius.circular(15),
                color: SoftColors.blueLight,
                //textColor: Custom_Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
        buttons: []).show();
  }

  void showDeleteDialog(Mark delMark) {
    Alert(
        style: AlertStyle(
          animationType: AnimationType.fromLeft,
          backgroundColor: SoftColors.blueLight,
          titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          isCloseButton: false,
        ),
        context: context,
        title: subject.name + ": " + delMark.value.toString(),
        desc: "Желаете удалить выбранную отметку?",
        content: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 15, top: 25),
                decoration: BoxDecoration(boxShadow: UnpressedShadow.shadow),
                child: DialogButton(
                  height: 40,
                  child: Text("Удалить",
                      style:
                          TextStyle(color: SoftColors.blueLight, fontSize: 20)),
                  radius: BorderRadius.circular(15),
                  color: SoftColors.blueDark,
                  //textColor: Colors.white,
                  onPressed: () {
                    databaseHelper.deleteMark(delMark.markId);
                    subject.marksKol--;
                    updateSubject();
                    Navigator.of(context).pop();
                    updateMarksList();
                  },
                )),
            Container(
              decoration: BoxDecoration(boxShadow: UnpressedShadow.shadow),
              child: DialogButton(
                height: 40,
                child: Text("Отмена",
                    style: TextStyle(color: SoftColors.blueDark, fontSize: 20)),
                radius: BorderRadius.circular(15),
                color: SoftColors.blueLight,
                //textColor: Custom_Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
        buttons: []).show();
  }

  @override
  Widget build(BuildContext context) {
    selectedMark.subjectId = subject.id;
    selectedMark.value = 1;

    if (marksList == null) {
      marksList = List<Mark>();
      updateMarksList();
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          //leading: Logo(),
          iconTheme: IconThemeData(
            color: SoftColors.blueDark
          ),
          title: Text(
            subject.name,
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
          child: GridView.count(
              padding: EdgeInsets.all(15.0),
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
              crossAxisCount: 5,
              children: buildMarks(subject)),
        ),
    );
  }

  List<Widget> buildMarks(Subject subject) {
    List<Widget> ret;
    ret = marksList
        .map((Mark x) => GestureDetector(
            onTap: () {
              showDeleteDialog(x);
            },
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    //color: Color(getColor(x.value)),
                    color: Color(0xFF82DD96),
                    boxShadow: UnpressedShadow.shadow),
                child: Center(
                  child: Text(
                    x.value.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ))))
        .toList();

    ret.add(GestureDetector(
      //onTap: navigateToAddScreen,
      onTap: showAddDialog,
      child: Container(
        child: Icon(
          Icons.add,
          color: SoftColors.blueDark,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: SoftColors.blueLight,
            boxShadow: UnpressedShadow.shadow),
      ),
    ));

    return ret;
  }
}
