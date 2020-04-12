import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/models/book.dart';
import 'package:school_diary/services/firestore_helper.dart';
import 'package:school_diary/widgets/soft_button.dart';
import 'package:school_diary/widgets/soft_listTile.dart';

class DownloadBooks1 extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return DownloadBooks1State();
  }
}

class DownloadBooks1State extends State<DownloadBooks1>{

  List<Book> data = [
    Book(fileName: "", subject: "Алгебра", form: 11, author: "Кузнецова")
  ];

  String percents = "1%";
  bool loading = true;

  List<Widget> buildList(){
    List<Widget> ret = List<Widget>();
    for (int i=0; i<data.length; i++){
      ret.add(SoftListTile(
        title: data[i].subject,
        subtitle: data[i].author,
        leading: data[i].form.toString(),
        trailing:  Container(child: Text(percents)),
        onTap: () {
          //await downloadBook(i, data[i]);
          percents="100%";
          setState(() {
            
          });
        },
      ));
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          //leading: Logo(),
          leading: Container(
            child: SvgPicture.asset('assets/Dzlogo.svg'),
            padding: EdgeInsets.all(10),
          ),
          title: Text(
            "Скачать учебники",
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
        child: Column(
          children: <Widget>[
            // Фильтры
            Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SoftButton(
                    child: Text("Класс", style: TextStyle(fontSize: 18),),
                    color: SoftColors.blueLight,
                    width: (MediaQuery.of(context).size.width/2)-30,
                    height: 40,
                    onTap: (){
                      
                    },
                  ),
                  SoftButton(
                    child: Text("Предмет", style: TextStyle(fontSize: 18),),
                    color: SoftColors.blueLight,
                    width: (MediaQuery.of(context).size.width/2)-30,
                    height: 40,
                    onTap: (){},
                  )
                ],
              ),
            ),
            // Список
            Container(
              child: this.data==null 
              ? Container(child: CircularProgressIndicator(),) 
              : Expanded(
                child: ListView(
                  children: buildList(),
                ),
              )
            )
          ],
        ),
      ),
    );
  }

}