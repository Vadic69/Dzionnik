import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:school_diary/constants.dart';

class ViewPdf extends StatefulWidget{
  final String path;

  const ViewPdf({Key key, this.path}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ViewPdfState();
  }

}

class ViewPdfState extends State<ViewPdf>{

  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController _pdfViewController;

  showAlert(){

    

    TextEditingController controller = TextEditingController(text: (_currentPage+1).toString());

    //TODO: UX
    Alert(
        context: context,
        title: 'Перейти на страницу',
        style: AlertStyle(
          animationType: AnimationType.fromBottom,
          backgroundColor: SoftColors.blueLight,
          titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          isCloseButton: false,
        ),
        content: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(left: 80, right: 80),
              child: TextFormField(
                controller: controller,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    //contentPadding: EdgeInsets.only(left: 20),
                    hintText: "Номер страницы",
                    hintStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 15, top: 15),
                decoration: BoxDecoration(boxShadow: UnpressedShadow.shadow),
                child: DialogButton(
                  height: 45,
                  child: Text("Перейти",
                      style:
                          TextStyle(color: SoftColors.blueLight, fontSize: 20)),
                  radius: BorderRadius.circular(15),
                  color: SoftColors.blueDark,
                  //textColor: Colors.white,
                  onPressed: () {
                    int p = int.parse(controller.text);
                    if (p>0 && p<_totalPages)
                      _pdfViewController.setPage(p-1);

                  },
                )),
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
        ),
        buttons: []).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: Container(
            child: SvgPicture.asset('assets/Dzlogo.svg'),
            padding: EdgeInsets.all(10),
          ),
          title: Text(
            "Расписание",
            style: Styles.appBarTextStyle
          ),
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
        body: Stack(
          children: <Widget>[
            PDFView(
              fitPolicy: FitPolicy.BOTH,
              filePath: widget.path,
              autoSpacing: true,
              enableSwipe: true,
              pageSnap: true,
              swipeHorizontal: true,
              nightMode: false,
              onError: (e) {
                print(e);
              },
              onRender: (_pages) {
                setState(() {
                  _totalPages = _pages;
                  pdfReady = true;
                });
              },
              onViewCreated: (PDFViewController vc) {
                _pdfViewController = vc;
              },
              onPageChanged: (int page, int total) {
                setState(() {_currentPage = page;});
              },
              onPageError: (page, e) {},
            ),
            !pdfReady
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Offstage()
          ],
        ),
        floatingActionButton: 
        FloatingActionButton(
          child: Text("${_currentPage+1}/$_totalPages"),
          backgroundColor: SoftColors.blueDark,
          onPressed: (){
            showAlert();
          },
        ),
    );
  }

}