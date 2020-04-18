import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/services/api.dart';
import 'package:fifagen/core/viewmodels/base_model.dart';
import 'package:flutter/widgets.dart';

class UserProfileViewModel extends BaseModel {
  Api _api;

  UserProfileViewModel({
    @required Api api,
  }) : _api = api;

  List<User> friends;
  Future findFriends(String userID) async {
    setBusy(true);
    friends = await _api.findFriends(userID, "friends");
    setBusy(false);
  }
}
