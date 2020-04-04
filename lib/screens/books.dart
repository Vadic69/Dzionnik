import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/models/book.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:school_diary/screens/view_pdf.dart';

class Books extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return BooksState();
  }

}

class BooksState extends State<Books>{

  List<Book> data = [
    Book(subject: "English", form: 11, author: "Витченко, Обух", fileName: "bel-mova-valochka-9kl-bel-rus-2019.pdf"),
    Book(subject: "Математика", form: 7, author: "Казаков"),
    Book(subject: "Информатика", form: 10, author: "Сидоров"),
    Book(subject: "Русский язык", form: 10, author: "Лапицкая"),
    Book(subject: "English", form: 6, author: "Витченко, Обух"),
  ];

  List<Widget> buildList(){
    List<Widget> ret = List<Widget>();
    for (int i=0; i<data.length; i++) {
      ret.add(SoftListTile(
        leading: data[i].form.toString(),
        title: data[i].subject,
        subtitle: data[i].author,
        onTap: (){
          readPDF(context, data[i].fileName);
        },
      ));
    }

    return ret;
  }

  Future<File> getFileFromAsset(String fileName) async {
    String asset = "assets/books/$fileName";
    print(asset);
    try {
      var data = await rootBundle.load(asset);
      print(data);
      var bytes = data.buffer.asUint8List();
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$fileName");

      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      print(e.toString());
    }
  }

  readPDF(BuildContext context, String fileName) async {
    File PDFFile = await getFileFromAsset(fileName);
    String PDFPath = PDFFile.path;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPdf(path: PDFPath)
      )
    );
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