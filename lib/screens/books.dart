import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/models/book.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:school_diary/screens/download_book.dart';
import 'package:school_diary/screens/view_pdf.dart';
import 'package:school_diary/services/database_helper.dart';
import 'package:school_diary/widgets/soft_listTile.dart';

class Books extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return BooksState();
  }

}

class BooksState extends State<Books>{

  List<Book> data = List<Book>();
  PDFDocument document;

  updateBooksList() async {
    data = await DatabaseHelper().getBooksList();
  }

  createBooksFolder() async {
    var dir = await getApplicationDocumentsDirectory();
    var folder = Directory("${dir.path}/books/");
    if (await folder.exists()){
      return;
    }
    folder.create(recursive: true);
  }

  List<Widget> buildList(){
    List<Widget> ret = List<Widget>();
    for (int i=0; i<data.length; i++) {
      ret.add(SoftListTile(
        leading: data[i].form.toString(),
        title: data[i].subject,
        subtitle: data[i].author,
        onTap: (){
          getDocument(data[i].fileName);
        },
      ));
    }

    return ret;
  }

  getDocument(String fileName) async {
    //document = await PDFDocument.fromAsset("assets/books/$fileName");
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/books/$fileName");
    bool b = await file.exists();
    print(b);
    if (!b) return;
    document = await PDFDocument.fromFile(file);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPdf(document: document)
      )
    );
  }

  onStart() async {
    await updateBooksList();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    onStart();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: SoftColors.blueDark, size: 30,), 
            onPressed: () async {
              var dir = await getApplicationDocumentsDirectory();
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => DownloadBooks(dir: dir.path, local: data,))
              );
              await updateBooksList();
              setState(() {
              });
            },
        )
        ],
          centerTitle: true,
          //leading: Logo(),
          leading: Container(
            child: SvgPicture.asset('assets/Dzlogo.svg'),
            padding: EdgeInsets.all(10),
          ),
          title: Text(
            "Учебники",
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
          children: buildList(),
        ),
      ),
    );
  }

}