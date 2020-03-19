import 'dart:async';

import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/models/hometask.dart';

class UnknownHometaskPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return UnknownHometaskPageState();
  }
}

class UnknownHometaskPageState extends State<UnknownHometaskPage>{
  List<Hometask> data;

  StreamSubscription<Event> onHometaskAddedSubscription;
  StreamSubscription<Event> onHometaskDeletedSubscription;
  StreamSubscription<Event> onHometaskUpdatedSubscription;

  onHometaskAdded(Event event) {
    setState(() {
      data.insert(0, Hometask.fromSnapshot(event.snapshot));
    });
  }

  onHometaskDeleted(Event event){
    setState(() {
      for (int i=0; i<data.length; i++)
      if (data[i].id == event.snapshot.key){
        data.removeAt(i);
        break;
      }
    });
  }

  onHometaskUpdated(Event event){
    setState(() {
      for (int i=0; i<data.length; i++)
      if (data[i].id == event.snapshot.key){
        data[i] = Hometask.fromSnapshot(event.snapshot);
        break;
      }
    });
  }

  @override
  void initState(){
    super.initState();

    //controller = PageController(initialPage: DateTime.now().weekday-1);
    data = List<Hometask>();

    Query htQuery = FirebaseDatabase.instance.reference().child("queries").orderByChild("answered").equalTo(false);
    onHometaskAddedSubscription = htQuery.onChildAdded.listen(onHometaskAdded);
    onHometaskDeletedSubscription = htQuery.onChildRemoved.listen(onHometaskDeleted);
    onHometaskUpdatedSubscription = htQuery.onChildChanged.listen(onHometaskUpdated);
  }

  @override
  void dispose(){
    onHometaskAddedSubscription.cancel();
    onHometaskDeletedSubscription.cancel();
    onHometaskUpdatedSubscription.cancel();
    super.dispose();
  }

  showAddDialog(){
    Alert(
        context: context,
        title: 'Добавить запрос',
        style: AlertStyle(
          animationType: AnimationType.fromBottom,
          backgroundColor: SoftColors.blueLight,
          titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          isCloseButton: false,
        ),
        content: AddAlert(),
        buttons: []).show();
  }

  showAnswerDialog(Hometask ht){
    TextEditingController titleController = TextEditingController();
    Alert(
        context: context,
        title: ht.subject+", "+getFullWeekday(ht.weekday).toLowerCase(),
        style: AlertStyle(
          animationType: AnimationType.fromBottom,
          backgroundColor: SoftColors.blueLight,
          titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          isCloseButton: false,
        ),
        content: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25),
              child: TextField(
                controller: titleController,
                style: TextStyle(),
                decoration: InputDecoration(
                    hintText: "Домашнее задание...",
                    hintStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),
            ),
            SizedBox(height: 15,),
            SizedBox(height: 20,),
            Container(
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
                    ht.answered = true;
                    ht.value = titleController.text;
                    FirebaseDatabase.instance.reference().child("queries").child(ht.id).set(ht.toJson());
                    Navigator.of(context).pop();
                  },
                )),
            SizedBox(height: 15,),
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
          ]
        ),
        
        buttons: []).show();
  }

  showDeleteDialog(BuildContext context, String id){
    showModalBottomSheet(context: context, builder: (BuildContext buildContext){
      return Container(
        height: 220,
        padding: EdgeInsets.all(15),
        color: SoftColors.blueLight,
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
              alignment: Alignment(0,-1),
              child: Icon(Icons.delete_outline, size: 50,),
            ),
            Text(
              "Вы уверены, что желаете удалить запрос?",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Container(
                margin: EdgeInsets.only(top: 20),          
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 140,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: SoftColors.red, width: 2),  
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: FlatButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text("Нет", style: TextStyle(color: SoftColors.red),),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 50,
                    decoration: BoxDecoration(
                      color: SoftColors.red,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: FlatButton(
                      onPressed: (){
                        FirebaseDatabase.instance.reference().child("queries").child(id).remove();
                        Navigator.of(context).pop();
                      },
                      child: Text("Да", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  String getWeekday(int wd) {
    if (wd == 1) return "Пн";
    if (wd == 2) return "Вт";
    if (wd == 3) return "Ср";
    if (wd == 4) return "Чт";
    if (wd == 5) return "Пт";
    if (wd == 6) return "Сб";
    if (wd == 7) return "Вс";
    return "ER";
  }

  String getFullWeekday(int wd) {
    if (wd == 1) return "Понедельник";
    if (wd == 2) return "Вторник";
    if (wd == 3) return "Среда";
    if (wd == 4) return "Четверг";
    if (wd == 5) return "Пятница";
    if (wd == 6) return "Суббота";
    if (wd == 7) return "Воскресенье";
    return "ER";
  }

  List<Widget> buildList(){
    List<Widget> ret = List<Widget>();
    for (int i=0; i<data.length; i++)
      ret.add(SoftListTile(
        onLongPress: (){
          showDeleteDialog(context, data[i].id);
        },
        onTap: (){
          showAnswerDialog(data[i]);
        },
        leading: getWeekday(data[i].weekday),
        title: data[i].subject,
        subtitle: data[i].author,
      ));
    ret.add(Container(
      width: 70,
      height: 60,
      margin: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SoftColors.blueLight,
        boxShadow: UnpressedShadow.shadow,
        borderRadius: BorderRadius.circular(35)
      ),
      child: Material(
        color: SoftColors.blueLight,
        borderRadius: BorderRadius.circular(35),
        
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35)
          ),
          child: Center(
            child: Icon(Icons.add, color: SoftColors.blueDark,),
          ),
          onTap: (){
            showAddDialog();
          },
        ),
      ),
    ));
    ret.add(Container(height: 1, margin: EdgeInsets.only(top: 50)));
    return ret;
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      color: SoftColors.blueLight,
      child: ListView(
        children: buildList(),
      ),
    );
  }

}


class AddAlert extends StatefulWidget{
  bool check;
  @override
  State<StatefulWidget> createState() {
    return AddAlertState();
  }
    
}

class AddAlertState extends State<AddAlert>{
  Widget weekdayCard(String text){
    return Container(
      
      child: Center(
        child: Text(text, style: TextStyle(),),
      ),
    );
  }

  
  bool this_week = true;
  int wd = DateTime.now().weekday;

  PageController controller = PageController(initialPage: DateTime.now().weekday-1);
  Hometask addedHT = Hometask(answered: false, author: "Вадим Козлов", class_id: "HBDJnjnjdk", author_id: "bfjbfhjdbfd");
  final titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25),
              child: TextField(
                controller: titleController,
                style: TextStyle(),
                decoration: InputDecoration(
                    hintText: "Введите название предмета",
                    hintStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),
            ),
            SizedBox(height: 15,),
            Text("День недели:", style: TextStyle(fontSize: 15, color: SoftColors.blueDark),),
            SizedBox(height: 8,),
            Container(
              width: 250,
              height: 45,
              decoration: BoxDecoration(
                boxShadow: PressedShadow.shadow,
                borderRadius: BorderRadius.circular(15)
              ),
              child: PageView(
                onPageChanged: (index){
                  wd = index+1;
                },
                scrollDirection: Axis.vertical,
                children: [
                  weekdayCard("Понедельник"),
                  weekdayCard("Вторник"),
                  weekdayCard("Среда"),
                  weekdayCard("Четверг"),
                  weekdayCard("Пятница"),
                  weekdayCard("Суббота"),
                ],
                controller: controller,
              ),
            ),
            SizedBox(height: 8,),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    setState(() {
                      this_week = !this_week;   
                    });
                  },
                  child: CustomSwitchButton(
                    backgroundColor: SoftColors.blueDark,
                    unCheckedColor: SoftColors.blueLight,
                    animationDuration: Duration(milliseconds: 400),
                    checkedColor: SoftColors.blueLight,
                    checked: this_week,
                    buttonWidth: 45,
                    buttonHeight: 25,
                    indicatorWidth: 20,
                    indicatorBorderRadius: 10,
                  ),
                ),
                SizedBox(width: 15,),
                Text(
                  this_week ? "Следующая неделя" : "Эта неделя",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
            SizedBox(height: 20,),
            Container(
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
                    addedHT.this_week = this_week;
                    addedHT.subject = titleController.text;
                    addedHT.weekday = wd;
                    print(addedHT.weekday);
                    FirebaseDatabase.instance.reference().child("queries").push().set(addedHT.toJson());
                    Navigator.of(context).pop();
                  },
                )),
            SizedBox(height: 15,),
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
        );
  }

}