import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/models/user.dart';
import 'package:school_diary/services/auth_service.dart';

class Input extends StatelessWidget{
  bool hidden;
  TextEditingController controller;
  String text;
  Input({this.controller, this.text, this.hidden});

  @override
  Widget build(BuildContext context) {
    return Container(
              child: TextField(
                obscureText: hidden,
                controller: controller,
                decoration: InputDecoration(
                  hintText: text,
                ),
              ),
              padding: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: UnpressedShadow.shadow
              ),
            );
  }

}

class RegisterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }

}

class RegisterPageState extends State<RegisterPage>{
  String goodName = null;
  String goodSurname = null;
  String goodEmail = null;
  String goodPassword = null;
  bool goodPasswordConfirm = true;

  TextEditingController nameController;
  TextEditingController surnameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController passwordConfirmController;

  String emailValidator(String value){
    if (value.isEmpty) return "Это поле не должно быть пустым";
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email имеет неверный формат';
    } else {
      return null;
    }
  }

  String passwordValidator(String value){
    int minValue = 8;
    if (value.length<minValue)
      return "Минимум "+minValue.toString()+" символов";
    return null;
  }

  String passwordConfirmValidator(String val1, String val2){
    if (val1 == val2)
      return null;
    return "Пароли не совпадают";
  }

  String nameValidator(String val){
    if (val.length>0)
    return null;
    return "Это поле не должно быть пустым";
  }



  @override
  void initState(){
    super.initState();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: SoftColors.blueLight,
          child: Column(
            children: <Widget>[
              SizedBox(height: 40,),
              SvgPicture.asset('assets/Dzlogo.svg', height: 80, color: SoftColors.blueDark,),
              SizedBox(height: 20),
              Text("Регистрация", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
              //name
              SizedBox(height: 30,),
              Container(
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      errorText: goodName,
                      errorStyle: TextStyle(color: SoftColors.red),
                      hintText: "Имя",
                    ),
                  ),
                  padding: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: UnpressedShadow.shadow
                  ),
                ),
              SizedBox(height: 20,),
              Container(
                  child: TextField(
                    controller: surnameController,
                    decoration: InputDecoration(
                      errorText: goodSurname,
                      errorStyle: TextStyle(color: SoftColors.red),
                      hintText: "Фамилия",
                    ),
                  ),
                  padding: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: UnpressedShadow.shadow
                  ),
                ),
              SizedBox(height: 20,),
              Container(
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      errorText: goodEmail,
                      errorStyle: TextStyle(color: SoftColors.red),
                      hintText: "E-mail",
                    ),
                  ),
                  padding: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: UnpressedShadow.shadow
                  ),
                ),
              SizedBox(height: 20,),
              Container(
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      errorText: goodPassword,
                      errorStyle: TextStyle(color: SoftColors.red),
                      hintText: "Пароль",
                    ),
                  ),
                  padding: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: UnpressedShadow.shadow
                  ),
                ),
              SizedBox(height: 20,),
              Container(
                  child: TextField(
                    obscureText: true,
                    controller: passwordConfirmController,
                    onChanged: (text){
                      goodPasswordConfirm = text==passwordController.text;
                    },
                    
                    decoration: InputDecoration(
                      errorText: goodPasswordConfirm ? null : "Пароли не совпадают",
                      errorStyle: TextStyle(color: SoftColors.red),
                      hintText: "Подтвердите пароль",
                    ),
                  ),
                  padding: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: UnpressedShadow.shadow
                  ),
                ),
              SizedBox(height: 20,),
              Container(
                //width: 300,
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
                      onTap: (){
                        setState((){
                          goodName = nameValidator(nameController.text);
                          goodSurname = nameValidator(surnameController.text);
                          goodPassword = passwordValidator(passwordController.text);
                          goodEmail = emailValidator(emailController.text);
                          if (goodName != null ||
                              goodSurname != null ||
                              goodEmail != null ||
                              goodPassword != null ||
                              !goodPasswordConfirm) return;
                          User newUser = User(
                            email: emailController.text,
                            password: passwordController.text,
                            name: nameController.text,
                            surname: surnameController.text,
                            grade_id: ""
                          );

                          AuthService().createUser(newUser);
                          Navigator.of(context).pop();
                        });
                      },
                      child: Center(child: Text(
                        "Зарегистрироваться",
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
            ],
          ),
        ),
      ),
    );
  }

}