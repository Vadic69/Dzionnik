import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:school_diary/constants.dart';

class ViewPdf extends StatefulWidget{
  final PDFDocument document;

  const ViewPdf({Key key, this.document}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ViewPdfState();
  }

}

class ViewPdfState extends State<ViewPdf>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: SoftColors.blueLight,
          child: PDFViewer(
            document: widget.document,
            lazyLoad: true,
          ),
        )
    );
  }

}