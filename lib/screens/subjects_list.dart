import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/models/subject.dart';
import 'package:school_diary/screens/subject_detail.dart';
import 'package:school_diary/services/database_helper.dart';
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

  void updateListView() async {
    subjectsList = await databaseHelper.getSubjectsList();
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
    List<Widget> ret = List<Widget>();
    for (Subject x in subjectsList)
      ret.add(SoftListTile(
        leading: x.averageMark.toString(),
        title: x.name,
        //subtitle: "",
        onTap: (){
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => MarksList(x)));
        },
        onLongPress: (){
          showDeleteDialog(x);
        },
      ));
    ret.add(GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        height: 0,
      ),
    ));
    return ret;
  }

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
          decoration: BoxDecoration(color: SoftColors.blueLight),
          child: ListView(
            children: buildList(),
          ),
        ),
    );
  }
}
