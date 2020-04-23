import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/models/hometask.dart';
import 'package:school_diary/services/database_helper.dart';
import 'package:school_diary/widgets/soft_button.dart';

class AddHometask extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AddHometaskState();
  }

}

class AddHometaskState extends State<AddHometask>{

  DateTime selectedDateTime;
  TextEditingController titleController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  String getTime(DateTime dateTime){
    String month = dateTime.month.toString();
    if (month.length<2)
      month="0"+month;

    String day = dateTime.day.toString();
    if (day.length<2)
      day="0"+day;

    String hour = dateTime.hour.toString();
    if (hour.length<2)
      hour="0"+hour;

    String minute = dateTime.minute.toString();
    if (minute.length<2)
      minute="0"+minute;

    return "До $day.$month, $hour:$minute";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          //leading: Logo(),
          iconTheme: IconThemeData(
              color: SoftColors.blueDark
          ),
          title: Text(
            "Добавить задание",
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
        width: double.infinity,
        color: SoftColors.blueLight,
        child: Column(
          children: <Widget>[
            SizedBox(height: 14,),
            Text("Предмет", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: UnpressedShadow.shadow
              ),
              child: TextField(
                controller: titleController,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10)
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text("Задание", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: UnpressedShadow.shadow
              ),
              child: TextField(
                controller: valueController,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10)
                ),
                maxLength: 140,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
            ),
            SizedBox(height: 10,),
            Text("Время", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: SoftButton(
                child: Text(
                  selectedDateTime==null ? "Не выбрано" : getTime(selectedDateTime),
                  style: TextStyle(fontSize: 18),
                ),
                height: 60,
                onTap: (){
                  DatePicker.showDateTimePicker(
                    context,
                    locale: LocaleType.ru,
                    currentTime: (selectedDateTime==null) ? DateTime.now() : selectedDateTime,
                    onConfirm: (date){
                      setState(() {
                        selectedDateTime = date;
                      });
                    }
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: 
        Container(
          padding: EdgeInsets.all(14),
          color: SoftColors.blueLight,
          child: SoftButton(
            child: Text("Добавить", style: TextStyle(color: Colors.white, fontSize: 20),),
            color: SoftColors.green,
            height: 60,
            onTap: () async {
              if (titleController.text.length<1){
                scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("Введите имя предмета"),
                  backgroundColor: SoftColors.red,
                ));
                return;
              }
              if (valueController.text.length<1){
                scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("Введите задание"),
                  backgroundColor: SoftColors.red,
                ));
                return;
              }
              if (selectedDateTime==null){
                scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("Введите дату и время"),
                  backgroundColor: SoftColors.red,
                ));
                return;
              }
              Hometask hometask = Hometask(
                subject: titleController.text, 
                value: valueController.text,
                dateTime: dateFormat.format(selectedDateTime)
              );
              await DatabaseHelper().insertHometask(hometask);
              Navigator.of(context).pop();
            },
          ),
        ),
    );
  }

}