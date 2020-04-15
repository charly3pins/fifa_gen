import 'package:fifagen/screen/notifications.dart';
import 'package:fifagen/screen/search_list.dart';
import 'package:flutter/widgets.dart';

import 'screen/login.dart';
import 'screen/home.dart';
import 'screen/user_profile.dart';
import 'screen/my_profile.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/login": (BuildContext context) => LoginScreen(),
  "/home": (BuildContext context) => HomeScreen(),
  "/myprofile": (BuildContext context) => MyProfileScreen(),
  "/search": (BuildContext context) => SearchListScreen(),
  "/userprofile": (BuildContext context) => UserProfileScreen(
      parentAction: NotificationsScreen().updateFriendRequests),
  "/notifications": (BuildContext context) => NotificationsScreen(),
};
