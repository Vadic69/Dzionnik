import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school_diary/constants.dart';

class SoftButton extends StatelessWidget{

  final Function onTap;
  final Color color;
  final Widget child;
  final double width, height;
  final BorderRadius borderRadius;
  final bool enableShadow;

  SoftButton({
    this.onTap, 
    this.child, 
    this.height, 
    this.width, 
    this.color,
    this.borderRadius,
    this.enableShadow
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: SoftColors.blueLight,
        borderRadius: (borderRadius==null) ? BorderRadius.circular(height/2) : borderRadius, 
        boxShadow: (enableShadow==null || enableShadow==true) ? UnpressedShadow.shadow : null
      ),
          child: Material(
            color: color,
            borderRadius: (borderRadius==null) ? BorderRadius.circular(height/2) : borderRadius, 
            child: InkWell(
             customBorder: RoundedRectangleBorder(
               borderRadius: (borderRadius==null) ? BorderRadius.circular(height/2) : borderRadius
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