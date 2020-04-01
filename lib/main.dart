import 'package:fifagen/routes.dart';
import 'package:fifagen/screen/user_profile.dart';

import 'package:flutter/material.dart';

import 'model/user.dart';

void main() => runApp(FifaGen());

class FifaGen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      routes: routes,
    );
  }
}
