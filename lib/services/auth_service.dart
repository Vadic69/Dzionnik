
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:school_diary/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;  
      if (user != null)
        return true;
      else
        return false;
    } catch (e) {
      return false;
    }
  }

  Future<String> userID () async {
    FirebaseUser user = await _auth.currentUser();
    String uid = user.uid.toString();
    return uid;
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }

  Future<String> createUser(User newUser) async {
    AuthResult createRes;
    try {
      createRes = await _auth.createUserWithEmailAndPassword(email: newUser.email, password: newUser.password);
      FirebaseUser resUser = createRes.user;
      if (resUser != null){
        Firestore.instance
        .collection("users")
        .document(resUser.uid)
        .setData(newUser.toJson());
      }  
    } catch (e) {
      //print(e);
      return e.message;
    }
    
  }
}