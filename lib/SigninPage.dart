import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _successText;
  bool _failure;
  String _failureText;
  String _userEmail;
  final key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login / Sign up"),
      ),
      body: ListView(
        key: key,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  size: 150,
                  color: Colors.white,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(labelText: 'Password'),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (value.length <= 6) {
                              return 'Please enter atleast 6 characters long password';
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              alignment: Alignment.center,
                              child: RaisedButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    _register();
                                  }
                                },
                                child: const Text('Sign Up'),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              alignment: Alignment.center,
                              child: RaisedButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    _signInWithEmailAndPassword();
                                  }
                                },
                                child: const Text('Sign In'),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            _success == null
                                ? ''
                                : _successText == null ? "" : _successText,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            _failure == null
                                ? ''
                                : _failureText == null ? "" : _failureText,
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code for registration.
  void _register() async {
    FirebaseUser user;
    Scaffold.of(key.currentContext).removeCurrentSnackBar();
    Scaffold.of(key.currentContext).showSnackBar(SnackBar(
      content: Text(
        "Please Wait We are Registering you...",
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
      backgroundColor: Colors.green,
    ));
    try {
      user = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (e) {
      setState(() {
        _failure = true;
        _failureText =
            "An error occured, check your internet connection or maybe this account is already created";
        _success = false;
        _successText = null;
      });
    }
    if (user != null) {
      setState(() {
        _failure = false;
        _failureText = null;
        _success = true;
        _userEmail = user.email;
        _successText = user.email + " registered successfully";
      });
      var encryptedPassword =
          Crypt.sha256(_passwordController.text + "@1234!").toString();
      await Firestore.instance
          .collection("parkingSlotsPassword")
          .document(user.uid)
          .setData({
        'password': encryptedPassword,
      });
      Scaffold.of(key.currentContext).removeCurrentSnackBar();
      Scaffold.of(key.currentContext).showSnackBar(SnackBar(
        content: Text(
          "You are registered Successfully",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.green,
      ));
    } else {
      setState(() {
        _failure = false;
        _failureText = null;
        _success = false;
        _successText =
            "An error occured, maybe this account is already created";
      });
      Scaffold.of(key.currentContext).showSnackBar(SnackBar(
        content: Text(
          "An error occured, maybe this account is already created",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.green,
      ));
    }
  }

  void _signInWithEmailAndPassword() async {
    FirebaseUser user;
    try {
      user = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (e) {
      setState(() {
        _failure = true;
        _failureText = e.toString();
        _success = false;
        _successText = null;
      });
    }
    if (user != null) {
      setState(() {
        _failure = false;
        _failureText = null;
        _success = true;
        _userEmail = user.email;
        _successText = "Successfully Logged in " + user.email;
      });
    } else {
      _failure = false;
      _failureText = null;
      _success = false;
      _successText =
          "An error occured maybe your email or password is wrong or account with this email is not created";
    }
  }
}
