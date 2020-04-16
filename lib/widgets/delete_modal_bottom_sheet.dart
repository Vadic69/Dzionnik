import 'package:flutter/material.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/widgets/soft_button.dart';

class DeleteModalBottomSheet extends StatelessWidget{
  double buttonWidth;
  Function onTap;
  String text;

  DeleteModalBottomSheet({this.text, this.onTap, this.buttonWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 224,
        padding: EdgeInsets.all(15),
        color: SoftColors.blueLight,
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
              alignment: Alignment(0,-1),
              child: Icon(Icons.delete_outline, size: 50,),
            ),
            Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
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
                  onTap: onTap,
                )
              ],
            )
            
          ],
        ),
      );
  }

}