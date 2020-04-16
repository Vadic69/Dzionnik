import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/models/book.dart';
import 'package:school_diary/services/database_helper.dart';
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

  DownloadBooksState({this.dir, this.local});

  String dir;
  List<Book> local, data;
  int mn=1,mx=11;
  String subjectFilter = "Предмет";
  String subjectSelected = "Предмет";
  String formFilter = "Класс";
  Set<String> subjects = Set<String>();
  int maxLen=20;
  
  DatabaseHelper dblocal = DatabaseHelper();
  List<String> percents = List<String>();
  Set<String> inLocal = Set<String>();
  Map<String, String> filterFromValue = Map<String, String>();

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
      
    }
    if (!this.mounted)
      return;

    inLocal.add(book.id);
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

  List<DropdownMenuItem<String>> buildFormsDropdownItems(){
    List<DropdownMenuItem<String>> ret = List<DropdownMenuItem<String>>();
    List<String> forms = [
      "Класс",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "11",
    ];
    for (int i=0; i<forms.length; i++){
      ret.add(DropdownMenuItem(
        value: forms[i],
        child: Text(forms[i]),
      ));
    }

    return ret;
  }

  String truncate(int maxLen, String val){
    if (val.length>maxLen)
      val = val.substring(0,maxLen-3)+"...";
    
    return val;
  }

  List<DropdownMenuItem<String>> buildSubjectsDropdownItems(){
    List<DropdownMenuItem<String>> ret = List<DropdownMenuItem<String>>();
    ret.add(DropdownMenuItem(
        value: "Предмет",
        child: Text(
          "Предмет",
          ),
      ));
    for (String subj in subjects){
      String txt= truncate(maxLen, subj);
      filterFromValue[txt]=subj;
      ret.add(DropdownMenuItem(
        value: txt,
        child: Text(txt),
      ));
    }

    return ret;
  }

  updateList() async {
    data = List<Book>();
    percents = List<String>();
    //QuerySnapshot ref = await Firestore.instance.collection("books").getDocuments();
    QuerySnapshot ref;
    if (subjectFilter=="Предмет")
      ref = await 
        Firestore
        .instance
        .collection("books")
        .where('form', isGreaterThanOrEqualTo: mn)
        .where('form', isLessThanOrEqualTo: mx)
        .getDocuments();
    else
      ref = await 
        Firestore
        .instance
        .collection("books")
        .where('form', isGreaterThanOrEqualTo: mn)
        .where('form', isLessThanOrEqualTo: mx)
        .where('subject', isEqualTo: subjectFilter)
        .getDocuments();

    for (int i=0; i<ref.documents.length; i++){
      data.add(Book.fromFirestore(ref.documents[i]));
      subjects.add(data[data.length-1].subject);
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
    double deviceWidth = MediaQuery.of(context).size.width;
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
              padding: EdgeInsets.only(left: 14, right: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SoftButton(
                    child: DropdownButton(
                      underline: Container(height: 0,),
                      items: buildFormsDropdownItems(),
                      value: formFilter,
                      onChanged: (String newValue){
                        if (newValue=="Класс"){
                          mn=1; mx=11;
                        } else {
                          int x=int.parse(newValue);
                          mx=x; mx=x; 
                        }
                        setState(() {
                          formFilter = newValue;
                          loading=true;
                          loadData();
                        });
                      }, 
                      
                    ),
                    color: SoftColors.blueLight,
                    width: (deviceWidth-42)-240,
                    height: 40,
                    onTap: (){
                    },
                  ),
                  SoftButton(
                    child: DropdownButton(
                      underline: Container(height: 0,),
                      items: buildSubjectsDropdownItems(),
                      value: (subjectSelected.isNotEmpty) ? subjectSelected : null,
                      onChanged: (String newValue){
                        setState(() {
                          subjectFilter = filterFromValue[newValue];
                          subjectSelected = truncate(maxLen, newValue);
                          loading=true;
                          loadData();
                        });
                      }, 
                      
                    ),
                    color: SoftColors.blueLight,
                    width: 240,
                    height: 40,
                    onTap: (){
                    },
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
                  valueColor: AlwaysStoppedAnimation<Color>(SoftColors.blueDark),
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