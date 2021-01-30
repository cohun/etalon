import 'package:etalon/services/auth.dart';
import 'package:etalon/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  var isWithEmail = false;
  var showSignIn = true;
  String email = '';
  String password = '';
  String fullName = 'Nobody';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal[900],
        title: showSignIn ? Text('Sign in') : Text('Register'),
        elevation: 0.0,
        actions: [
          FlatButton.icon(
            onPressed: () {
              setState(() {
                showSignIn = !showSignIn;
              });
            },
            icon: Icon(Icons.person),
            label: showSignIn ? Text('Register') : Text('Sign in'),
          ),
        ],
      ),
      body: loading
          ? Loading()
          : Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('lib/assets/images/fractal_green.jpg'),
                    SingleChildScrollView(
                      child: isWithEmail
                          ? showSignIn
                              ? _signinWithEmail(context)
                              : _registerWithEmail()
                          : Column(
                              children: [
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
                                      print('${result.url}');
                                    }
                                  },
                                  backgroundColor: Colors.orange[700],
                                ),
                                SignInButtonBuilder(
                                  text: 'Sign in with Email',
                                  icon: Icons.email,
                                  onPressed: () {
                                    setState(() {
                                      isWithEmail = true;
                                    });
                                  },
                                  backgroundColor: Colors.blueGrey[700],
                                ),
                                SignInButton(
                                  Buttons.Google,
                                  text: "Sign up with Google",
                                  onPressed: () async {
                                    dynamic result =
                                        await _auth.signInWithGoogle();
                                    if (result == null) {
                                      print('error signing in');
                                    } else {
                                      print('signed in');
                                      print((result.uid));
                                      print('${result.url}');
                                    }
                                  },
                                ),
                                SignInButton(
                                  Buttons.FacebookNew,
                                  text: "Sign up with Facebook",
                                  onPressed: () async {
                                    dynamic result =
                                        await _auth.signInWithFacebook();
                                    if (result == null) {
                                      print('error signing in');
                                    } else {
                                      print('signed in');
                                      print((result.uid));
                                      print('${result.url}');
                                    }
                                  },
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
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _signinWithEmail(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              emailFormField(),
              SizedBox(
                height: 20,
              ),
              passwordFormField(),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                  color: Colors.purple[800],
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.signinWithEmailAndPassword(
                          email, password, context);
                      if (result == null) {
                        setState(() {
                          loading = false;
                        });
                      }
                    }
                  }),
              SizedBox(
                height: 12,
              ),
              Text(error),
            ],
          )),
    );
  }

  TextFormField passwordFormField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'password',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
      ),
      validator: (val) => val.length < 6 ? 'Min length 6 chars' : null,
      obscureText: true,
      onChanged: (val) {
        setState(() {
          return password = val;
        });
      },
    );
  }

  TextFormField emailFormField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'email',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
      ),
      validator: (val) => val.isEmpty ? 'Enter an email' : null,
      onChanged: (val) {
        setState(() {
          return email = val;
        });
      },
    );
  }

  TextFormField nameFormField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Full name',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
      ),
      validator: (val) => val.isEmpty ? 'Enter your name' : null,
      onChanged: (val) {
        setState(() {
          return fullName = val;
        });
      },
    );
  }

  Widget _registerWithEmail() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              emailFormField(),
              SizedBox(
                height: 20,
              ),
              nameFormField(),
              SizedBox(
                height: 20,
              ),
              passwordFormField(),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                  color: Colors.purple[800],
                  child: Text(
                    'Sign up',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        loading = true;
                      });
                      dynamic result =
                          await _auth.registerWithEmailAndPasssword(
                              email, fullName, password);
                      if (result == null) {
                        setState(() {
                          loading = false;
                          return error = 'please supply a valid email';
                        });
                      }
                    }
                  }),
              SizedBox(
                height: 12,
              ),
              Text(error),
            ],
          )),
    );
  }
}
