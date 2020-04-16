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
import 'package:school_diary/widgets/soft_button.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

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
        onLongPress: (){
          showDeleteBottomSheet(data[i]);
          setState(() {
          });
        },
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
    if (!b) return;
    document = await PDFDocument.fromFile(file);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPdf(document: document)
      )
    );
  }

  deleteBook(Book book) async {
    
    var dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}/books/${book.fileName}";
    File file = File(path);
    if (await file.exists())
      file.delete();

    await DatabaseHelper().deleteBook(book.id);

    data.removeWhere((item) => item==book);
  }

  showDeleteBottomSheet(Book book){
    double screenWidth = MediaQuery.of(context).size.width;
    double margin = 14;
    double buttonWidth = (screenWidth - 3*margin)/2;
    showModalBottomSheet(context: context, builder: (BuildContext buildContext){
      return Container(
        height: 230,
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
              book.subject,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10,),
            Text("Вы уверены, что хотите удалить учебник из памяти устройства?", textAlign: TextAlign.center,),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SoftButton(
                  child: Text("Отмена"),
                  height: 50,
                  width: buttonWidth,
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
                SoftButton(
                  color: SoftColors.red,
                  child: Text("Удалить", style: TextStyle(color: Colors.white),),
                  height: 50,
                  width: buttonWidth,
                  onTap: () async {
                    await deleteBook(book);
                    Navigator.of(context).pop();
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("Учебник удалён"),
                      backgroundColor: SoftColors.green,
                    ));
                    updateBooksList();
                    setState(() {
                    });
                  },
                )
              ],
            )
            
          ],
        ),
      );
    });
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
      key: scaffoldKey,
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
        child: (data.length!=0) 
        ? ListView(
          children: buildList(),
        )
        : Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text("У Вас пока нет скачанных учебников", style: TextStyle(color: SoftColors.blueDark),),
                SizedBox(height: 14,),
                SoftButton(
                  child: Icon(Icons.arrow_downward, color: SoftColors.blueDark,),
                  color: SoftColors.blueLight,
                  height: 60,
                  width: 60,
                  onTap: () async {
                    var dir = await getApplicationDocumentsDirectory();
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) => DownloadBooks(dir: dir.path, local: data,))
                    );
                    await updateBooksList();
                    setState(() {
                    });
                  },
                ),
              ],
            ),
          ),
      ),
    );
  }

}