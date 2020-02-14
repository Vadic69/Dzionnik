import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/database_helper.dart';
import 'package:school_diary/models/subject.dart';
import 'package:school_diary/screens/subject_detail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubjectsList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SubjectsListState();
  }
}

class SubjectsListState extends State<SubjectsList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Subject> subjectsList;
  int count = 0;
  bool tap = true;

  SubjectsListState({this.subjectsList});

  @override
  Widget build(BuildContext context) {
    if (subjectsList == null) {
      subjectsList = List<Subject>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
          actions: <Widget>[
            IconButton(
              //onTap: navigateToAddScreen,
              onPressed: (){
                showAddSubject();
              },
              icon: Icon(Icons.add, color: SoftColors.blueDark, size: 30,),
            ),
          ],
          centerTitle: true,
          //leading: Logo(),
          leading: Container(
            child: SvgPicture.asset('assets/Dzlogo.svg'),
            padding: EdgeInsets.all(10),
          ),
          title: Text(
            "Предметы",
            style: TextStyle(
                fontSize: 25, color: Colors.black, fontWeight: FontWeight.w600),
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
          decoration: BoxDecoration(color: SoftColors.blueLight),
          child: ListView(
            children: buildList(),
          ),
        ),
    );
  }

  void showAddSubject() {
    Subject addedSubject =
        Subject(id: 0, name: "NoName", marksKol: 0, averageMark: 0);
    final titleController = TextEditingController();

    Alert(
        context: context,
        title: 'Добавить предмет',
        style: AlertStyle(
          animationType: AnimationType.fromBottom,
          backgroundColor: SoftColors.blueLight,
          titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          isCloseButton: false,
        ),
        content: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25),
              child: TextField(
                controller: titleController,
                onChanged: (text) {
                  addedSubject.name = titleController.text;
                },
                style: TextStyle(),
                decoration: InputDecoration(

                    hintText: "Введите название",
                    hintStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(

                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),
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
                    saveData(addedSubject);
                    updateListView();
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

  void saveData(Subject addedSubject) async {
    int result;
    result = await databaseHelper.insertSubject(addedSubject);
    if (result != 0) {
      //print("Success!");
      //print(addedSubject.name);
    } else {
      //print("ERROR!");
    }
    Navigator.pop(context, true);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.inicializeDatabase();
    dbFuture.then((database) {
      Future<List<Subject>> subjListFuture = databaseHelper.getSubjectsList();
      subjListFuture.then((subjList) {
        setState(() {
          this.subjectsList = subjList;
        });
      });
    });
  }

  String getSubjString(int kol) {
    if (kol % 10 == 1 && (kol < 10 || kol > 19)) return "Отметка";
    if (kol % 10 >= 2 && kol % 10 <= 4 && (kol < 10 || kol > 19))
      return "Отметки";
    return "Отметок";
  }

  void showDeleteDialog(Subject delSubj) {
    Alert(
        style: AlertStyle(
          animationType: AnimationType.fromLeft,
          backgroundColor: SoftColors.blueLight,
          titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          isCloseButton: false,
        ),
        context: context,
        title: delSubj.name,
        desc: "Желаете удалить выбранный предмет? Все отметки также удалятся, отменить действие будет невозможно.",
        content: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 15, top: 25),
                decoration: BoxDecoration(boxShadow: UnpressedShadow.shadow),
                child: DialogButton(
                  height: 45,
                  child: Text("Удалить",
                      style:
                          TextStyle(color: SoftColors.blueLight, fontSize: 20)),
                  radius: BorderRadius.circular(15),
                  color: SoftColors.red.withOpacity(0.8),
                  //textColor: Colors.white,
                  onPressed: () {
                    databaseHelper.deleteSubject(delSubj.id);
                    databaseHelper.deleteMarks(delSubj.id);
                    Navigator.of(context).pop();
                    updateListView();
                  },
                )),
            Container(
              decoration: BoxDecoration(boxShadow: UnpressedShadow.shadow),
              child: DialogButton(
                height: 45,
                child: Text("Отмена",
                    style: TextStyle(color: Colors.black, fontSize: 20)),
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

  List<Widget> buildList() {

    List<Widget> ret = subjectsList
        .map((Subject x) => GestureDetector(
            onLongPress: () {
              showDeleteDialog(x);
            },
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MarksList(x)));
            },
            child: AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.ease,
              padding: EdgeInsets.only(top: 7.0, bottom: 7.0),
              margin: EdgeInsets.only(left: 14.0, right: 14.0, top: 20.0),
              decoration: BoxDecoration(
                  color: SoftColors.blueLight,
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  boxShadow: UnpressedShadow.shadow),
              child: ListTile(
                  leading: Container(
                    width: 45.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF82DD96),
                    ),
                    child: Center(
                      child: Text(
                        x.averageMark.toString(),
                        style: TextStyle(
                            //fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF),
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                  title: Text(
                    x.name,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  trailing: Container(
                      width: 45,
                      height: 45,
                      child: Center(
                        child: ListView(
                          children: <Widget>[
                            Text(
                              x.marksKol.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                //fontWeight: FontWeight.w600
                              ),
                            ),
                            Text(
                              getSubjString(x.marksKol),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 8),
                            )
                          ],
                        ),
                      ))),
            )))
        .toList();
    ret.add(GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        height: 0,
      ),
    ));
    return ret;
  }
}
