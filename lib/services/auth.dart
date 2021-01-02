import 'package:etalon/models/my_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create MyUser based on FirebaseUser
  MyUser _createMyUser(User user) {
    return user != null
        ? MyUser(name: user.displayName, uid: user.uid, url: user.photoURL)
        : null;
  }

  // auth change user stream
  Stream<MyUser> get user => _auth.authStateChanges().map(_createMyUser);

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential credential = await _auth.signInAnonymously();
      User firebaseUser = credential.user;
      return _createMyUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
