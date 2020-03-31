import 'screen/login.dart';

import 'package:flutter/material.dart';

void main() => runApp(FifaGen());

class FifaGen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
