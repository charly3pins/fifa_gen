import 'package:fifagen/core/models/friendship.dart';
import 'package:fifagen/core/models/user.dart';

class UserProfileViewArguments {
  User user;
  Friendship friendship;

  UserProfileViewArguments({this.user, this.friendship});
}
