import 'package:fifagen/models/user.dart';
import 'package:fifagen/screens/home.dart';
import 'package:fifagen/screens/login.dart';
import 'package:flutter/material.dart';

/// Builds the home or login UI, depending on the user.
/// This widget should be below the [MaterialApp].
/// An [AuthWidgetBuilder] ancestor is required for this widget to work.
class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return user != null ? HomeScreen() : LoginScreen();
  }
}
