import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/models/hometask.dart';

class KnownHometaskPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return KnownHometaskPageState();
  }
}

class KnownHometaskPageState extends State<KnownHometaskPage>{

  List<Hometask> data;

  StreamSubscription<Event> onHometaskAddedSubscription;
  StreamSubscription<Event> onHometaskDeletedSubscription;

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

  @override
  void initState(){
    super.initState();

    data = List<Hometask>();

    Query htQuery = FirebaseDatabase.instance.reference().child("queries").orderByChild("answered").equalTo(true);
    onHometaskAddedSubscription = htQuery.onChildAdded.listen(onHometaskAdded);
    onHometaskDeletedSubscription = htQuery.onChildRemoved.listen(onHometaskDeleted);
  }

  @override
  void dispose(){
    onHometaskAddedSubscription.cancel();
    onHometaskDeletedSubscription.cancel();
    super.dispose();
  }

  void showValue(Hometask ht){
    showModalBottomSheet(context: context, builder: (BuildContext buildContext){
      return Container(
        height: 160,
        padding: EdgeInsets.all(15),
        //color: SoftColors.blueLight,
        child: Column(
          children: <Widget>[
            Text(
              ht.subject+", "+getFullWeekday(ht.weekday).toLowerCase(),
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 15,),
            Text(ht.value, style: TextStyle(fontSize: 20, color: SoftColors.blueDark),)
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
        onTap: (){
          showValue(data[i]);
        },
        leading: getWeekday(data[i].weekday),
        title: data[i].subject,
        subtitle: data[i].author,
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