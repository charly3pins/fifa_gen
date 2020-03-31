import 'user_profile.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

enum AuthMode { LOGIN, SIGNUP }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // To adjust the layout according to the screen size
  // so that our layout remains responsive ,we need to
  // calculate the screen height
  double screenHeight;

  final _loginFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  final _user = User();

  // Set initial mode to login
  AuthMode _authMode = AuthMode.SIGNUP;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          upperHalf(context),
          _authMode == AuthMode.SIGNUP
              ? signUpCard(context)
              : loginCard(context),
          pageTitle(),
        ],
      ),
    );
  }

  Widget pageTitle() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.assessment,
            size: 48,
            color: Colors.white,
          ),
          Text(
            "Fifa Generator",
            style: TextStyle(
                fontSize: 34, color: Colors.white, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Widget loginCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenHeight / 4),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Username", hasFloatingPlaceholder: true),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your Username.';
                        }
                        return null;
                      },
                      onSaved: (val) =>
                          setState(() => _user.username = val.trim()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                      onSaved: (val) =>
                          setState(() => _user.password = val.trim()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {},
                          child: Text("Forgot Password ?"),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        FlatButton(
                          child: Text("Login"),
                          color: Color(0xFF4B9DFE),
                          textColor: Colors.white,
                          padding: EdgeInsets.only(
                              left: 38, right: 38, top: 15, bottom: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () {
                            final form = _loginFormKey.currentState;
                            if (form.validate()) {
                              form.save();
                              _user.name = ""; // TODO check how to improve this cleaning method
                              API().loginUser(_user).then((usr) {
                                // Navigate to new page without back
                                // TODO Navigator.pushReplacement(context,
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      // TODO resume page
                                      return UserProfilePage(user: usr);
                                    }));
                              }).catchError((e) {
                                // TODO improve this error check
                                showDialog(
                                    context: context,
                                    builder: (_) =>
                                        AlertDialog(title: Text(e)));
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
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
              textColor: Colors.white,
              child: Text("Create Account"),
            )
          ],
        ),
      ],
    );
  }

  Widget signUpCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenHeight / 5),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Your Name", hasFloatingPlaceholder: true),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your Name.';
                        }
                        return null;
                      },
                      onSaved: (val) => setState(() => _user.name = val.trim()),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Your Username",
                          hasFloatingPlaceholder: true),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your Username.';
                        }
                        return null;
                      },
                      onSaved: (val) =>
                          setState(() => _user.username = val.trim()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                      onSaved: (val) =>
                          setState(() => _user.password = val.trim()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        FlatButton(
                          child: Text("Sign Up"),
                          color: Color(0xFF4B9DFE),
                          textColor: Colors.white,
                          padding: EdgeInsets.only(
                              left: 38, right: 38, top: 15, bottom: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () {
                            final form = _signUpFormKey.currentState;
                            if (form.validate()) {
                              form.save();
                              API().createUser(_user).then((usr) {
                                // Navigate to new page without back
                                // TODO Navigator.pushReplacement(context,
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      // TODO profile page
                                      return UserProfilePage(user: usr);
                                    }));
                              }).catchError((e) {
                                // TODO improve this error check
                                showDialog(
                                    context: context,
                                    builder: (_) =>
                                        AlertDialog(title: Text(e)));
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
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
              textColor: Colors.white,
              child: Text("Login"),
            )
          ],
        ),
      ],
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight,
      child: Image.asset('assets/fifa-20-bg.jpeg', fit: BoxFit.fill),
    );
  }
}

class API {
  Future<User> createUser(User user) async {
    final String baseURL = 'http://10.0.2.2:8000';
    String jsonBody = json.encode(user.toJSON());
    final response = await http.post(baseURL + "/users",
        headers: {"Content-Type": 'application/json'}, body: jsonBody);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return User.fromJSON(jsonData);
    }

    return Future.error(response.body);
  }

  Future<User> loginUser(User user) async {
    final String baseURL = 'http://10.0.2.2:8000';
    String jsonBody = json.encode(user.toJSON());
    final response = await http.post(baseURL + "/token",
        headers: {"Content-Type": 'application/json'}, body: jsonBody);

    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return User.fromJSON(jsonData);
    }

    return Future.error(response.body);
  }
}

class User {
  final String id;
  String name;
  String username;
  String password;

  User({this.id, this.name, this.username, this.password});

  factory User.fromJSON(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson['id'],
      name: parsedJson['name'],
      username: parsedJson['username'],
      password: parsedJson['password'],
    );
  }

  Map<String, dynamic> toJSON() => {
    "name": name,
    "username": username,
    "password": password,
  };
}
