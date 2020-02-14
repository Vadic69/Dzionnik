import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Custom_Colors {
  static const red = Color(0xFFE44652);
  static const blue = Color(0xFF043353);
  static const white = Color(0xFFFAF8F0);
}

class SoftColors {
  static const blueLight = Color(0xFFF1F3F6);
  static const blueDark = Color(0xFF798BCB);
  static const blueShadow = Color(0xFF3754AA);
  static const green = Color(0xFF82DD96);
  static const red = Color(0xFFE44652);
}

class UnpressedShadow {
  static dynamic shadow = [
    BoxShadow(
      color: Color(0xFF3754AA).withOpacity(0.26),
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
