import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:etalon/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:etalon/models/my_user.dart';

class Home extends StatelessWidget {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
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
                  'logout',
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
          CircleAvatar(
            radius: 80,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
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
