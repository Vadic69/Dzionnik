import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/models/hometask.dart';
import 'package:school_diary/screens/add_hometask.dart';
import 'package:school_diary/services/database_helper.dart';
import 'package:school_diary/widgets/soft_button.dart';
import 'package:school_diary/widgets/soft_listTile.dart';

class Notifications extends StatefulWidget{
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  static DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  List<Hometask> ht = List<Hometask>();

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

  showBottomSheet(Hometask hometask){
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        height: 310,
        child: Column(
          children: <Widget>[
            SizedBox(height: 14,),
            Text(
              hometask.subject,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            SizedBox(height: 7,),
            Text(getTime(dateFormat.parse(hometask.dateTime))),
            SizedBox(height: 14,),
            Container(
              height: 1, 
              color: SoftColors.blueDark.withOpacity(0.5),
              margin: EdgeInsets.only(left: 14, right: 14),
            ),
            SizedBox(height: 14,),
            Container(
              padding: EdgeInsets.all(14),
              child: Text(hometask.value, style: TextStyle(fontSize: 18),),
              height: 140,
              ),
            Padding(
              padding: EdgeInsets.all(14.0),
              child: SoftButton(
                onTap: () async {
                  Navigator.of(context).pop();
                  await DatabaseHelper().deleteHometask(hometask.id);
                  updateList();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.done, color: Colors.white,),
                    SizedBox(width: 14,),
                    Text(
                      "Выполнено", 
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
                color: SoftColors.green,
                height: 50,
              ),
            )
          ],
        ),
      );
    });
  }

  List<Widget> buildList(){
    List<Widget> ret = List<Widget>();
    ht.sort((a,b){
      DateTime da,db;
      da = dateFormat.parse(a.dateTime);
      db = dateFormat.parse(b.dateTime);
      if (da.isBefore(db))
        return -1;
      if (da.isAfter(db))
        return 1;
      return 0;
    });

    int j=0;
    for (int i=0; i<ht.length; i++)
    {
      if (dateFormat.parse(ht[i].dateTime).isBefore(DateTime.now()) == false)
        break;
      j++;
      if (i==0){
        ret.add(
          Text(
            "ПРОСРОЧЕНО!!!", 
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: SoftColors.red
            ),
          ),
        );
      }
      ret.add(SoftListTile(
        leadingWidget: Icon(Icons.warning, color: Colors.white,),
        leadingColor: SoftColors.red,
        title: ht[i].subject,
        subtitle: getTime(dateFormat.parse(ht[i].dateTime)),
        onTap: (){
          showBottomSheet(ht[i]);
        },
      ));
      
    }
    
    for (int i=j; i<ht.length; i++){
      if (j==i){
        if (ret.length!=0) ret.add(SizedBox(height: 14));
        ret.add(Text(
          "Актуальное",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: SoftColors.blueDark,
            fontWeight: FontWeight.w600
          ),
        )
      );
      }
      
      ret.add(SoftListTile(
        leadingWidget: Icon(Icons.schedule, color: SoftColors.blueDark,),
        leadingColor: SoftColors.blueLight,
        title: ht[i].subject,
        subtitle: getTime(dateFormat.parse(ht[i].dateTime)),
        onTap: (){
          showBottomSheet(ht[i]);
        },
      ));
    }

    return ret;
  }

  updateList() async {
    ht = await DatabaseHelper().getHometaskList();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    updateList();
    return Scaffold(
      appBar: AppBar(
          leading: Container(
            child: SvgPicture.asset('assets/Dzlogo.svg'),
            padding: EdgeInsets.all(10),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add, color: SoftColors.blueDark,),
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context){return AddHometask();}
                ));
              },
            )
          ],
          centerTitle: true,
          //leading: Logo(),
          iconTheme: IconThemeData(
              color: SoftColors.blueDark
          ),
          title: Text(
            "Домашнее задание",
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
        child: ListView(
          padding: EdgeInsets.only(top: 14),
          children: buildList(),
        ),
      ),
    );
  }
}