import 'package:fifagen/core/constants/app_constants.dart';
import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/ui/views/home_view.dart';
import 'package:fifagen/ui/views/login_view.dart';
import 'package:fifagen/ui/views/notification_list_view.dart';
import 'package:fifagen/ui/views/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (_) => HomeView());
      case RoutePaths.Login:
        return MaterialPageRoute(builder: (_) => LoginView());
      case RoutePaths.Notifications:
        var friendRequests = settings.arguments as List<User>;
        return MaterialPageRoute(
            builder: (_) => NotificationListView(
                  friendRequests: friendRequests,
                ));
      case RoutePaths.UserProfile:
        var user = settings.arguments as User;
        return MaterialPageRoute(builder: (_) => UserProfileView(user: user));
      // case RoutePaths.Post:
      //   var post = settings.arguments as Post;
      //   return MaterialPageRoute(builder: (_) => PostView(post: post));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
