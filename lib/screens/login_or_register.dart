import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/screens/login.dart';
import 'package:school_diary/screens/register.dart';

class LoginOrRegisterPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: SoftColors.blueLight,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset('assets/Dzlogo.svg', height: 100,),
              SizedBox(height: 30,),
              Text("Упс... Вы не авторизованы", style: TextStyle(fontSize: 24), textAlign: TextAlign.center,),
              SizedBox(height: 30,),
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
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
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
        ),
      ),
    );
  }

}