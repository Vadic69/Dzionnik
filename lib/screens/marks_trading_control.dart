import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:school_diary/screens/login.dart';
import 'package:school_diary/screens/login_or_register.dart';
import 'package:school_diary/screens/splash_screen.dart';

import 'marks_trading.dart';

class  MarksTradingControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) 
          return SplashScreen();
        if (snapshot.data == null || !snapshot.hasData)
          return LoginOrRegisterPage();
        return MarksTrading();
      },
    );
  }

}