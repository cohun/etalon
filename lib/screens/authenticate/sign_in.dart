import 'package:etalon/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal[900],
        title: Text('Sign in'),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('lib/assets/images/fractal_green.jpg'),

            SignInButtonBuilder(
              text: 'Sign in anon',
              icon: Icons.attribution_outlined,
              onPressed: () async {
                dynamic result = await _auth.signInAnon();
                if (result == null) {
                  print('error signing in');
                } else {
                  print('signed in');
                  print((result.uid));
                }
              },
              backgroundColor: Colors.orange[700],
            ),
            SignInButtonBuilder(
              text: 'Sign in with Email',
              icon: Icons.email,
              onPressed: () {},
              backgroundColor: Colors.blueGrey[700],
            ),
            SignInButton(
              Buttons.Google,
              text: "Sign up with Google",
              onPressed: () {},
            ),
            SignInButton(
              Buttons.FacebookNew,
              text: "Sign up with Facebook",
              onPressed: () {},
            ),
            SignInButton(
              Buttons.Apple,
              text: "Sign up with Apple",
              onPressed: () {},
            ),
            SignInButton(
              Buttons.Microsoft,
              text: "Sign up with Microsoft",
              onPressed: () {},
            ),
            SignInButton(
              Buttons.Pinterest,
              text: "Sign up with Pinterest",
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
