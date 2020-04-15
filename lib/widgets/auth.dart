import 'package:fifagen/notifiers/auth_api.dart';
import 'package:fifagen/screens/home.dart';
import 'package:fifagen/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authNotif = Provider.of<AuthNotifier>(context);

    return authNotif.isLoggedIn ? HomeScreen() : LoginScreen();
  }
}
