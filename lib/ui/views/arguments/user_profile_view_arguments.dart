import 'package:fifagen/core/models/user.dart';

class UserProfileViewArguments {
  User user;
  int friendshipStatus;

  UserProfileViewArguments({this.user, this.friendshipStatus});
}
