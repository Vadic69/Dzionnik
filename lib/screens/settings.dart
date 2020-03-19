import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_diary/constants.dart';
import 'package:school_diary/models/user.dart';
import 'package:school_diary/services/auth_service.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}



class SettingsPageState extends State<SettingsPage> {
  User curUser = User();
  
  getCurrentUser () async {
    FirebaseUser cur = await FirebaseAuth.instance.currentUser();
    if (cur != null){
      curUser.id = cur.uid;
      var data = await Firestore.instance.collection("users").document(curUser.id).get();
      curUser.name = data["name"];
      curUser.surname = data["surname"];
    }
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          //leading: Logo(),
          leading: Container(
            child: SvgPicture.asset('assets/Dzlogo.svg'),
            padding: EdgeInsets.all(10),
          ),
          title: Text(
            "Настройки",
            style: Styles.appBarTextStyle
          ),
          backgroundColor: SoftColors.blueLight,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Container(
              height: 1,
              color: SoftColors.blueDark.withOpacity(0.5),
              width: MediaQuery.of(context).size.width * 0.9,
              //margin: EdgeInsets.only(bottom: 20),
            ),
          )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        //padding: EdgeInsets.all(14),
        color: SoftColors.blueLight,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: SoftColors.blueLight,
                boxShadow: UnpressedShadow.shadow,
                borderRadius: BorderRadius.circular(20)
              ),
              child: StreamBuilder(
                stream: FirebaseAuth.instance.onAuthStateChanged,
                builder: (context, AsyncSnapshot<FirebaseUser> snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) 
                    return Center(child: Text("Загрузка аккаунта..."),);
                  if (snapshot.data == null || !snapshot.hasData)
                    return Text("Не авторизован");
                  curUser.id = snapshot.data.uid;
                  return StreamBuilder(
                    stream: Firestore.instance.collection("users").document(curUser.id).snapshots(),
                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Text("Загрузка...");
                      curUser.name = snapshot.data["name"];
                      curUser.surname = snapshot.data["surname"];
                      return Column(
                        children: [
                          SizedBox(height: 15,),
                          Text("Текущий пользователь:", style: TextStyle(color: Colors.black.withOpacity(0.7)),),
                          SizedBox(height: 10,),
                          Text(curUser.name+" "+curUser.surname, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),// account
                          SizedBox(height: 5,),
                          Text("ID:", style: TextStyle(fontSize: 20, color: Colors.black.withOpacity(0.5)),),
                          SizedBox(height: 5,),
                          GestureDetector(
                            onTap: (){
                              Clipboard.setData(ClipboardData(text: curUser.id)).then((result){
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("ID скопирован в буфер обмена"),
                                ));
                              });
                            },
                            child: Text(curUser.id, style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.5)),)
                          ),
                          SizedBox(height: 20,),
                          Material(
                            color: SoftColors.red,
                            borderRadius: BorderRadius.circular(20),
                              child: InkWell(
                                customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Container(
                                  
                                  child: Text("Выйти", style: TextStyle(color: Colors.white, fontSize: 18),),
                                  width: 100,
                                  height: 40,
                                  alignment: Alignment(0,0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: SoftColors.red,
                                    boxShadow: [
                                      BoxShadow(
                                        //color: Color(0xFF3754AA).withOpacity(0.26),
                                        color: SoftColors.red.withOpacity(0.5),
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
                                  onTap: (){
                                    AuthService().logOut();
                                  },
                              ),
                          ),
                          SizedBox(height: 20,),
                        ]
                      );
                    }
                  );
                },
              ),
            ),
            Container(

            )
          ],
        ),
      ),
    );
  }

}