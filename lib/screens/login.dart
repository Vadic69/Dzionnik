import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school_diary/services/auth_service.dart';

import '../constants.dart';


class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController(text: "");
    TextEditingController _passwordController = TextEditingController(text: "");
    return Container(
      color: SoftColors.blueLight,
      alignment: Alignment(0,0),
      padding: EdgeInsets.all(50),
      child: Column(
        children: <Widget>[
          SizedBox(height: 160,),
          Text(
            "Авторизация",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 30),
          Container(
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "E-mail",
              ),
            ),
            padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: UnpressedShadow.shadow
            ),
          ),
          SizedBox(height: 20,),
          Container(
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: "Пароль",
              ),
            ),
            padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: UnpressedShadow.shadow
            ),
          ),

          SizedBox(height: 20,),
          Container(
            width: 300,
            height: 60,
            decoration: BoxDecoration(
              boxShadow: UnpressedShadow.shadow,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Material(
                color: SoftColors.blueDark,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                  ),
                  onTap: () async {
                    bool res = await AuthService().signInWithEmail(_emailController.text, _passwordController.text);
                  },
                  child: Center(child: Text(
                    "Войти",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20
                    ),
                  )
                  ),
              ),
            ),
          ),
          SizedBox(height: 15,),
          Container(
            width: 300,
            height: 60,
            decoration: BoxDecoration(
              boxShadow: UnpressedShadow.shadow,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Material(
                color: SoftColors.blueLight,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                  ),
                  onTap: (){
                    print("1");
                  },
                  child: Center(child: Text(
                    "Регистрация",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20
                    ),
                  )
                  ),
              ),
            ),
          )
        ],
      ),
    );
  }

}