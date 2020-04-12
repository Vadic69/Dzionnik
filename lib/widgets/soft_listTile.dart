import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school_diary/constants.dart';

class SoftListTile extends StatelessWidget{

  final Function onTap, onLongPress;
  final String leading, title, subtitle;
  final Widget trailing;

  SoftListTile({this.onTap, this.leading, this.subtitle, this.title, this.onLongPress, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 14.0, right: 14.0, top: 20.0),
      decoration: BoxDecoration(
        color: SoftColors.blueLight,
        borderRadius: BorderRadius.all(Radius.circular(35.0)),
        boxShadow: UnpressedShadow.shadow),
          child: Material(
            color: SoftColors.blueLight,
            borderRadius: BorderRadius.circular(35),
            child: InkWell(
             customBorder: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(35)
             ),
            onTap: onTap,
            onLongPress: onLongPress,
            child: Container(
              padding: subtitle!=null ? null : EdgeInsets.only(top: 5, bottom: 5),
              child: ListTile(
                leading: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: SoftColors.green
                  ),
                  child: Center(
                    child: Text(leading, style: TextStyle(color: Colors.white, fontSize: 20),),
                  ),
                ),
                title: Text(title),
                subtitle: subtitle==null ? null : Text(subtitle),
                trailing: trailing,
          ),
            ),
        ),
      ),
    );
  }

}