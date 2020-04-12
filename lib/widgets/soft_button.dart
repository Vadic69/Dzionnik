import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school_diary/constants.dart';

class SoftButton extends StatelessWidget{

  final Function onTap;
  final Color color;
  final Widget child;
  final double width, height;

  SoftButton({
    this.onTap, 
    this.child, 
    this.height, 
    this.width, 
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: SoftColors.blueLight,
        borderRadius: BorderRadius.all(Radius.circular(height/2)),
        boxShadow: UnpressedShadow.shadow),
          child: Material(
            color: color,
            borderRadius: BorderRadius.circular(height/2),
            child: InkWell(
             customBorder: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(height/2)
             ),
            onTap: onTap,
            child: Container(
              child: child,
              alignment: Alignment(0,0),
            ),
        ),
      ),
    );
  }

}