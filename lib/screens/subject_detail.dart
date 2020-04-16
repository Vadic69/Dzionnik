import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_diary/models/subject.dart';
import 'package:school_diary/models/mark.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/services/database_helper.dart';
import 'package:school_diary/widgets/delete_modal_bottom_sheet.dart';
import 'package:school_diary/widgets/soft_button.dart';
import 'package:sqflite/sqflite.dart';

class MarksList extends StatefulWidget {
  final Subject subject;

  MarksList(this.subject);

  @override
  State<StatefulWidget> createState() {
    return MarksListState(this.subject);
  }
}

class MarksListState extends State<MarksList> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Mark> marksList;
  Subject subject;

  MarksListState(this.subject);

  Mark selectedMark = Mark(value: 10);

  DatabaseHelper databaseHelper = DatabaseHelper();

  void saveData() async {
    int result;
    result = await databaseHelper.insertMark(selectedMark);
    if (result != 0) {
      subject.marksKol++;
      updateSubject();
    } else {
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

  List<Widget> buildRow(int l, int r){
    double screenWidth = MediaQuery.of(context).size.width;
    double margin = 14;
    double kol = (r-l+1)+0.0;
    double buttonWidth = (screenWidth-margin*(kol+1))/kol;
    List<Widget> ret = List<Widget>();
    for (int i=l; i<=r; i++){
      ret.add(SoftButton(
        child: Text(
          i.toString(),
          style: TextStyle(
            color: SoftColors.blueDark,
            fontSize: 22,
            )
          ),
        height: buttonWidth,
        width: buttonWidth,
        onTap: (){
          selectedMark.value = i;
          saveData();
          updateMarksList();
        },
      )
    );
    }

    return ret;
  }

  showAddBottomSheet(){
    double screenWidth = MediaQuery.of(context).size.width;
    double margin = 14;
    double kol = 5;
    double buttonWidth = (screenWidth-margin*(kol+1))/kol;
    showModalBottomSheet(context: context, builder: (context){
      return Container(
      height: margin*4+buttonWidth*2+44,
        padding: EdgeInsets.all(14),
        child: Column(
          children: <Widget>[
            Text(
              "Добавить отметку",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: buildRow(1,5),
            ),
            SizedBox(height: 14, width: double.infinity,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: buildRow(6,10),
            ),
            SizedBox(height: 14, width: double.infinity,),
          ],
        ),
      );
    });
  }

  showDeleteMarksBottomSheet(Mark delMark){
    double screenWidth = MediaQuery.of(context).size.width;
    double margin = 14;
    double buttonWidth = (screenWidth - 3*margin)/2;
    showModalBottomSheet(context: context, builder: (context){
      return DeleteModalBottomSheet(
        buttonWidth: buttonWidth,
        text: "Вы действительно хотите удалить отметку? (${delMark.value})",
        onTap: () async {
          int res = await databaseHelper.deleteMark(delMark.markId);
          subject.marksKol--;
          updateSubject();
          Navigator.of(context).pop();
          updateMarksList();
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: (res==1) ? Text("Отметка была успешно удалена") : Text("Ошибка"),
            backgroundColor: (res==1) ? SoftColors.green : SoftColors.red,
          ));
        },
      );
    });
  }

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    selectedMark.subjectId = subject.id;
    selectedMark.value = 10;

    if (marksList == null) {
      marksList = List<Mark>();
      updateMarksList();
    }

    return Scaffold(
      key: scaffoldKey,
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
              showDeleteMarksBottomSheet(x);
            },
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    //color: Color(getColor(x.value)),
                    color: SoftColors.green,
                    boxShadow: UnpressedShadow.shadow),
                child: Center(
                  child: Text(
                    x.value.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      //fontWeight: FontWeight.w600,
                    ),
                  ),
                ))))
        .toList();

    ret.add(GestureDetector(
      //onTap: navigateToAddScreen,
      onTap: showAddBottomSheet,
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
