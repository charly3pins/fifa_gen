import 'package:fifagen/models/user.dart';
import 'package:fifagen/notifiers/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthMode { LOGIN, SIGNUP }

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthMode _authMode = AuthMode.LOGIN;

  final _formKey = GlobalKey<FormState>();
  final _user = User();

  @override
  Widget build(BuildContext context) {
    final _authNotif = Provider.of<AuthNotifier>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Fifa Generator",
      )),
      // resizeToAvoidBottomPadding: false,
      body: _buildForm(context, _authNotif),
    );
  }

  Widget _buildForm(BuildContext context, AuthNotifier authNotif) {
    return Column(
      children: <Widget>[
        Container(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Username", hasFloatingPlaceholder: true),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your Username.';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => _user.username = val.trim()),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Password", hasFloatingPlaceholder: true),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a Password.';
                    }
                    return null;
                  },
                  obscureText: true,
                  onSaved: (val) => setState(() => _user.password = val.trim()),
                ),
                SizedBox(height: 20),
                FlatButton(
                  child: _authMode == AuthMode.LOGIN
                      ? Text("Log in")
                      : Text("Sign up"),
                  color: Color(0xFF4B9DFE),
                  textColor: Colors.white,
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      _authMode == AuthMode.LOGIN
                          ? authNotif.logIn(_user)
                          : authNotif.signUp(_user);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        _authMode == AuthMode.LOGIN
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40),
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _authMode = AuthMode.SIGNUP;
                      });
                    },
                    textColor: Colors.black,
                    child: Text("Create an account"),
                  )
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40),
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _authMode = AuthMode.LOGIN;
                      });
                    },
                    textColor: Colors.black,
                    child: Text("Log in to your account"),
                  )
                ],
              ),
      ],
    );
  }
}
