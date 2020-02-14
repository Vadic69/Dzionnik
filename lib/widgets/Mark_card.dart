import 'package:flutter/cupertino.dart';

class MarkCard extends StatelessWidget{
  String value;
  double fontSize;
  MarkCard({this.value, this.fontSize});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        value,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: fontSize),
      ),
    );
  }
}