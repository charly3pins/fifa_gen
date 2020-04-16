import 'package:fifagen/models/user.dart';
import 'package:fifagen/notifiers/auth_api.dart';
import 'package:fifagen/widgets/snack_bar_launcher.dart';
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
  var _user = User();

  @override
  Widget build(BuildContext context) {
    final _authNotif = Provider.of<AuthNotifier>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Fifa Generator",
      )),
      body: _buildForm(context, _authNotif),
    );
  }

  Widget _buildForm(BuildContext context, AuthNotifier authNotif) {
    return Container(
        color: Color.fromRGBO(36, 43, 47, 1),
        padding: const EdgeInsets.symmetric(horizontal: 43.0),
        child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _authMode == AuthMode.SIGNUP
                      ? TextFormField(
                          decoration: _buildInputDecoration("Name"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your Name.';
                            }
                            return null;
                          },
                          style: TextStyle(
                              color: Color.fromRGBO(252, 252, 252, 1),
                              fontFamily: 'RadikalLight'),
                          onSaved: (val) =>
                              setState(() => _user.name = val.trim()),
                        )
                      : Container(),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: _buildInputDecoration("Username"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Username.';
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: Color.fromRGBO(252, 252, 252, 1),
                        fontFamily: 'RadikalLight'),
                    onSaved: (val) =>
                        setState(() => _user.username = val.trim()),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: _buildInputDecoration("Password"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a Password.';
                      }
                      return null;
                    },
                    obscureText: true,
                    style: TextStyle(
                        color: Color.fromRGBO(252, 252, 252, 1),
                        fontFamily: 'RadikalLight'),
                    onSaved: (val) =>
                        setState(() => _user.password = val.trim()),
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    child: Text(
                      _authMode == AuthMode.LOGIN ? "Log in" : "Sign up",
                      style: TextStyle(
                          color: Color.fromRGBO(40, 48, 52, 1),
                          fontFamily: 'RadikalMedium',
                          fontSize: 14),
                    ),
                    color: Colors.white,
                    elevation: 4.0,
                    onPressed: () {
                      final form = _formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        _authMode == AuthMode.LOGIN
                            ? authNotif.logIn(_user)
                            : authNotif.signUp(_user);
                        form.reset();
                        _user = User();
                      }
                    },
                  ),
                  _authMode == AuthMode.LOGIN
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 40),
                            Text(
                              "Not a member?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            FlatButton(
                              onPressed: () {
                                setState(() {
                                  _authMode = AuthMode.SIGNUP;
                                  authNotif.clearError();
                                });
                              },
                              textColor: Colors.white,
                              child: Text("Sign up"),
                            )
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 40),
                            Text(
                              "Already a member?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            FlatButton(
                              onPressed: () {
                                setState(() {
                                  _authMode = AuthMode.LOGIN;
                                  authNotif.clearError();
                                });
                              },
                              textColor: Colors.white,
                              child: Text("Log in"),
                            )
                          ],
                        ),
                  Consumer<AuthNotifier>(
                    builder: (context, authNotif, child) =>
                        SnackBarLauncher(error: authNotif.error),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  InputDecoration _buildInputDecoration(String hint) {
  return InputDecoration(
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(252, 252, 252, 1))),
      hintText: hint,
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(151, 151, 151, 1))),
      hintStyle: TextStyle(color: Color.fromRGBO(252, 252, 252, 1)),
      //icon: iconPath != '' ? Image.asset(iconPath) : null,
      errorStyle: TextStyle(color: Color.fromRGBO(248, 218, 87, 1)),
      errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color:  Color.fromRGBO(248, 218, 87, 1))),
      focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color:  Color.fromRGBO(248, 218, 87, 1))));
}
}
