import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  DataBaseService({this.uid});

  final String uid;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Add user
  Future<void> addUser(String name, String url) {
    return users
        .add({
          'full_name': name,
          'uid': uid,
          'url': url,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // Read user
  Future<void> updateUser(String name, String url) {
    return users
        .doc(uid)
        .set({
          'full_name': name,
          'uid': uid,
          'url': url,
        })
        .then((value) => print('user added'))
        .catchError((error) => print('Failed to add user: $error'));
  }
}
