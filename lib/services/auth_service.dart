
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
}