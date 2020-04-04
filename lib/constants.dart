import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Custom_Colors {
  static const red = Color(0xFFE44652);
  static const blue = Color(0xFF043353);
  static const white = Color(0xFFFAF8F0);
}

class SoftColors {
  static const blueLight = Color(0xFFF1F3F6);
  //static const blueDark = Color(0xFF798BCB);
  static const blueDark = Color(0xFF5D78D8);
  static const blueShadow = Color(0xFF3754AA);
  //static const green = Color(0xFF82DD96);
  static const green = Color(0xFF46B198);
  static const red = Color(0xFFE44652);
}

class UnpressedShadow {
  static dynamic shadow = [
    BoxShadow(
      //color: Color(0xFF3754AA).withOpacity(0.26),
      color: SoftColors.blueDark.withOpacity(0.3),
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0xFFFFFFFF),
      blurRadius: 15,
      offset: Offset(-5, -5),
    )
  ];
}

class PressedShadow {
  static dynamic shadow = <BoxShadow>[
    BoxShadow(
      color: SoftColors.blueDark.withOpacity(0.3),
      offset: Offset(0,0),
    ),
    BoxShadow(
      color: SoftColors.blueLight,
      offset: Offset(0,0),
      spreadRadius: -2,
      blurRadius: 3
    )
  ];
}

class SoftStyles {
  static const alertStyle = AlertStyle(
    animationType: AnimationType.fromLeft,
    backgroundColor: SoftColors.blueLight,
    titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
    isCloseButton: false,
  );
}

class Styles {
  static const appBarTextStyle = TextStyle(
      fontSize: 22,
      color: Colors.black,
      fontWeight: FontWeight.w600
  );
}

class SoftListTile extends StatelessWidget{

  final Function onTap, onLongPress;
  final String leading, title, subtitle;

  SoftListTile({this.onTap, this.leading, this.subtitle, this.title, this.onLongPress});

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
          ),
            ),
        ),
      ),
    );
  }

}

class CustomButton extends StatelessWidget{
  Color color, splashColor, shadowColor;
  double width, height;
  Widget child;
  Function onTap;

  CustomButton({this.color, this.splashColor, this.child, this.onTap, this.shadowColor, this.height, this.width});

  @override
  Widget build(BuildContext context) {
  return Material(
    color: color,
    borderRadius: BorderRadius.circular(20),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          child: child,
          width: width,
          height: height,
          alignment: Alignment(0,0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: SoftColors.red,
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
              BoxShadow(
                color: Color(0xFFFFFFFF),
                blurRadius: 15,
                offset: Offset(-5, -5),
              )
            ]
          )),
          onTap: onTap
      ),
  );
  }

}


