import 'package:etalon/models/my_user.dart';
import 'package:etalon/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create MyUser based on FirebaseUser
  MyUser _createMyUser(User user) {
    return user != null
        ? MyUser(name: user.displayName, uid: user.uid, url: user.photoURL)
        : null;
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // auth change user stream
  Stream<MyUser> get user => _auth.authStateChanges().map(_createMyUser);

  // sign in anon
  Future<MyUser> signInAnon() async {
    try {
      UserCredential credential = await _auth.signInAnonymously();
      User firebaseUser = credential.user;
      return _createMyUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPasssword(
      String email, String fullName, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User firebaseUser = userCredential.user;
      await DataBaseService(uid: firebaseUser.uid).updateUser(fullName, '');
      return _createMyUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return null;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // sign in with email & password
  Future signinWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User firebaseUser = userCredential.user;
      return _createMyUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            if (e.code == 'user-not-found') {
              return AlertDialog(
                title: Text('Sign in failed'),
                content: Text('No user found for that email. ${e.code}'),
                actions: [
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            } else if (e.code == 'wrong-password') {
              return AlertDialog(
                title: Text('Sign in failed'),
                content:
                    Text('Wrong password provided for that user. ${e.code}'),
                actions: [
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            }
            return Container(
              height: 0,
            );
          });
    }
    return null;
  }

  // sign in with Google
  Future<MyUser> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        // Create a new credential
        final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // Once signed in, return the UserCredential
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        return _createMyUser(userCredential.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  // sign in with Facebook
  Future<MyUser> signInWithFacebook() async {
    // Trigger the sign-in flow
    final AccessToken _accessToken = await FacebookAuth.instance.login();
    if (_accessToken != null) {
      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(_accessToken.token);

      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await _auth.signInWithCredential(facebookAuthCredential);
      return _createMyUser(userCredential.user);
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }
}
