import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/services/database_helper.dart';
import 'package:school_diary/widgets/delete_modal_bottom_sheet.dart';
import 'package:school_diary/widgets/soft_listTile.dart';

class SettingsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }

}

class SettingsPageState extends State<SettingsPage>{

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  showDeleteMarksBottomSheet(){
    double screenWidth = MediaQuery.of(context).size.width;
    double margin = 14;
    double buttonWidth = (screenWidth - 3*margin)/2;
    showModalBottomSheet(context: context, builder: (context){
      return DeleteModalBottomSheet(
        buttonWidth: buttonWidth,
        text: "Вы действительно хотите очистить список отметок?",
        onTap: () async {
          int res = await DatabaseHelper().clearMarksTable();
          Navigator.of(context).pop();
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: (res>=0) ? Text("Отметки были успешно удалены") : Text("Ошибка"),
            backgroundColor: (res>=0) ? SoftColors.green : SoftColors.red,
          ));
        },
      );
    });
  }

  showDeleteSubjectsBottomSheet(){
    double screenWidth = MediaQuery.of(context).size.width;
    double margin = 14;
    double buttonWidth = (screenWidth - 3*margin)/2;
    showModalBottomSheet(context: context, builder: (context){
      return DeleteModalBottomSheet(
        buttonWidth: buttonWidth,
        text: "Вы действительно хотите очистить список предметов?",
        onTap: () async {
          int res = await DatabaseHelper().clearMarksTable();
          int res2 = await DatabaseHelper().clearSubjectsTable();
          Navigator.of(context).pop();
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: (res2>=0) ? Text("Список предметов успешно очищен") : Text("Ошибка"),
            backgroundColor: (res2>=0) ? SoftColors.green : SoftColors.red,
          ));
        },
      );
    });
  }

  showDeleteScheduleBottomSheet(){
    double screenWidth = MediaQuery.of(context).size.width;
    double margin = 14;
    double buttonWidth = (screenWidth - 3*margin)/2;
    showModalBottomSheet(context: context, builder: (context){
      return DeleteModalBottomSheet(
        buttonWidth: buttonWidth,
        text: "Вы действительно хотите очистить расписание уроков?",
        onTap: () async {
          int res = await DatabaseHelper().clearScheduleTable();
          Navigator.of(context).pop();
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: (res>=0) ? Text("Расписание успешно очищено") : Text("Ошибка"),
            backgroundColor: (res>=0) ? SoftColors.green : SoftColors.red,
          ));
        },
      );
    });
  }

  showDeleteBellsBottomSheet(){
    double screenWidth = MediaQuery.of(context).size.width;
    double margin = 14;
    double buttonWidth = (screenWidth - 3*margin)/2;
    showModalBottomSheet(context: context, builder: (context){
      return DeleteModalBottomSheet(
        buttonWidth: buttonWidth,
        text: "Вы действительно хотите очистить расписание звонков?",
        onTap: () async {
          int res = await DatabaseHelper().clearBellsTable();
          Navigator.of(context).pop();
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: (res>=0) ? Text("Расписание звонков успешно очищено") : Text("Ошибка"),
            backgroundColor: (res>=0) ? SoftColors.green : SoftColors.red,
          ));
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          leading: Container(
            child: SvgPicture.asset('assets/Dzlogo.svg'),
            padding: EdgeInsets.all(10),
          ),
          title: Text(
            "Настройки",
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
            SoftListTile(
              title: "Очистить отметки",
              leadingWidget: Icon(Icons.clear, color: Colors.white,),
              subtitle: "Все предметы станут пустыми",
              onTap: (){
                showDeleteMarksBottomSheet();
              },
            ),
            SoftListTile(
              title: "Очистить список предметов",
              leadingWidget: Icon(Icons.school, color: Colors.white,),
              subtitle: "Все отметки тоже удалятся",
              onTap: (){
                showDeleteSubjectsBottomSheet();
              },
            ),
            SoftListTile(
              title: "Очистить расписание",
              leadingWidget: Icon(Icons.schedule, color: Colors.white,),
              subtitle: "Удалить расписание уроков",
              onTap: (){
                showDeleteScheduleBottomSheet();
              },
            ),
            SoftListTile(
              title: "Очистить расписание звонков",
              leadingWidget: Icon(Icons.notifications_active, color: Colors.white,),
              onTap: (){
                showDeleteBellsBottomSheet();
              },
            ),
          ],
        ),
      ),
    );
  }

}