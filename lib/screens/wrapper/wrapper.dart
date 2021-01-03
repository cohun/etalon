import 'package:etalon/models/my_user.dart';
import 'package:etalon/screens/authenticate/authenticate.dart';
import 'package:etalon/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    print(user);

    return user != null ? Home() : Authenticate();
  }
}
