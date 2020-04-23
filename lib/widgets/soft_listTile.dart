import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school_diary/constants.dart';

class SoftListTile extends StatelessWidget{

  final Function onTap, onLongPress;
  final String leading, title, subtitle;
  final Widget trailing, leadingWidget;
  final Color leadingColor;

  SoftListTile({
    this.onTap, 
    this.leading, 
    this.subtitle, 
    this.title, 
    this.onLongPress, 
    this.trailing, 
    this.leadingWidget, 
    this.leadingColor=SoftColors.green
  });

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
                    color: leadingColor
                  ),
                  child: Center(
                    child: (leadingWidget==null) 
                    ? Text(leading, style: TextStyle(color: Colors.white, fontSize: 20),)
                    : leadingWidget,
                  ),
                ),
                title: Text(
                  title,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                  ),
                subtitle: subtitle==null 
                ? null 
                : Text(
                  subtitle,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
                trailing: trailing,
          ),
            ),
        ),
      ),
    );
  }

}