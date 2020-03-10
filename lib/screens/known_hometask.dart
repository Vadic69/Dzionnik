import 'package:flutter/material.dart';
import 'package:school_diary/constants.dart';

class KnownHometaskPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return KnownHometaskPageState();
  }
}

class KnownHometaskPageState extends State<KnownHometaskPage>{

  List<Widget> buildList(){
    List<Widget> ret = List<Widget>();
    for (int i=0; i<8; i++)
    ret.add(Container(
      child: ListTile(
        title: Text("Английский язык"),
        subtitle: Text("Вадим Козлов"),
      ),
    ));

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