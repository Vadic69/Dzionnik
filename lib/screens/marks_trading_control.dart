import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:school_diary/screens/login.dart';
import 'package:school_diary/screens/splash_screen.dart';

import 'marks_trading.dart';

class  MarksTradingControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot){
        if (!snapshot.hasData)
          return SplashScreen();
        if (snapshot.data == null)
          return LoginPage();
        return MarksTrading();
      },
    );
  }

}