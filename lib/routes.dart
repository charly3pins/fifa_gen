import 'package:flutter/widgets.dart';

import 'screen/login.dart';
import 'screen/home.dart';
import 'screen/user_profile.dart';


final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => LoginPage(),
  "/home": (BuildContext context) => HomeScreen(),
  "/userprofile": (BuildContext context) => UserProfileScreen(),
};