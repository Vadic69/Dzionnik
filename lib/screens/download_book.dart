import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/models/book.dart';
import 'package:school_diary/services/database_helper.dart';
import 'package:school_diary/services/firestore_helper.dart';
import 'package:school_diary/widgets/soft_button.dart';
import 'package:school_diary/widgets/soft_listTile.dart';

class DownloadBooks extends StatefulWidget{

  String dir;
  List<Book> local = List<Book>();
  DownloadBooks({this.dir, this.local});

  @override
  State<StatefulWidget> createState() {
    return DownloadBooksState(dir: dir, local: local);
  }
}

class DownloadBooksState extends State<DownloadBooks>{

  String dir;
  List<Book> local, data;

  DownloadBooksState({this.dir, this.local});
  DatabaseHelper dblocal = DatabaseHelper();
  List<String> percents = List<String>();
  Set<String> inLocal = Set<String>();
  FirestoreHelper db = FirestoreHelper();

  bool loading = true;

  Widget status(int index){
    if (inLocal.contains(data[index].id)){
      return
        Icon(
          Icons.done,
          color: SoftColors.green,
        );
    }
    if (percents[index]==""){
      return 
        Icon(
          Icons.arrow_downward
        );
    }
    return Text(percents[index], style: TextStyle(color: Color(0xFF5f6064)),);
  }

  downloadBook(int index, Book book) async {
    String fileName = book.fileName;

    final StorageReference ref = FirebaseStorage.instance.ref().child("books").child(fileName);

    Dio dio = Dio();
    try {
      await dio.download(
      await ref.getDownloadURL(), 
      "$dir/books/$fileName", 
      onReceiveProgress: (current, total){
        setState(() {
          double per = (current / total) * 100;
          int progress = per.round();
          percents[index]="$progress%";
        });
      });
    } catch (e) {
      print(e.toString());
    }
    if (!this.mounted)
      return;

    inLocal.add(book.id);
    print(book.id);
    await dblocal.insertBook(book);
  }

  List<Widget> buildList(){
    List<Widget> ret = List<Widget>();
    for (int i=0; i<data.length; i++){
      ret.add(SoftListTile(
        title: data[i].subject,
        subtitle: data[i].author,
        leading: data[i].form.toString(),
        trailing: status(i),
        onTap: () async {
          if (inLocal.contains(data[i].id))
            return;
          await downloadBook(i, data[i]);
          if (this.mounted)
          setState((){
          });
        },
      ));
    }

    ret.add(SizedBox(
      height: 30,
    ));
    return ret;
  }

  updateList() async {
    data = List<Book>();
    QuerySnapshot ref = await Firestore.instance.collection("books").getDocuments();
    for (int i=0; i<ref.documents.length; i++){
      data.add(Book.fromFirestore(ref.documents[i]));
      percents.add("");
    }
    for (int i=0; i<local.length; i++)
        inLocal.add(local[i].id);
  }

  void loadData() async {
    await updateList();
    setState(() {
      loading = false;  
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (data==null){
      loadData();
    }
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
              child: loading 
              ? Container(
                height: 200, 
                child: Center(child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(SoftColors.blueDark),
                )),
              ) 
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