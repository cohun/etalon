import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:etalon/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:etalon/models/my_user.dart';

class Home extends StatelessWidget {
  final _auth = AuthService();
  String name = 'Nobody';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    final users = GetUserName(user.uid);
    print('print: $users');

    return SafeArea(
      child: Container(
        child: Scaffold(
          backgroundColor: Colors.deepPurple[50],
          appBar: AppBar(
            title: Text('Home'),
            backgroundColor: Colors.deepPurple[800],
            actions: [
              FlatButton.icon(
                onPressed: () async {
                  return await _auth.signOut();
                },
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                label: Text(
                  'logout ${user.name}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          body: UserData(user: user),
        ),
      ),
    );
  }
}

class UserData extends StatelessWidget {
  const UserData({
    Key key,
    @required this.user,
  }) : super(key: key);

  final MyUser user;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          user.url != null
              ? CircleAvatar(
            radius: 60,
                  backgroundImage: NetworkImage(user.url),
                  backgroundColor: Colors.transparent,
                )
              : CircleAvatar(
            radius: 60,
                  child: Image.asset('lib/assets/images/MR_NOBODY.png'),
                  backgroundColor: Colors.transparent,
                ),
          SizedBox(
            height: 25,
          ),
          Text(
            '${user.name}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('${user.uid}'),
        ],
      ),
    );
  }
}

class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Text("Full Name: ${data['full_name']}");
        }

        return Text("loading");
      },
    );
  }
}
