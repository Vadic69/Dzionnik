import 'package:flutter/material.dart';
import 'package:school_diary/constants.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: SoftColors.blueDark,
      child: Center(
        child: Container(
          
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("D", style: TextStyle(color: SoftColors.blueDark, fontWeight: FontWeight.w600, fontSize: 45),),
              Container(child: Text("z", style: TextStyle(color: SoftColors.blueDark, fontWeight: FontWeight.w600),), alignment: Alignment(0,0.75),),
            ],
          ),
        ),
      ),
    );
  }
}
