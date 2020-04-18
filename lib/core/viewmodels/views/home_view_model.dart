import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/services/api.dart';
import 'package:fifagen/core/services/authentication_service.dart';
import 'package:fifagen/core/viewmodels/base_model.dart';
import 'package:flutter/widgets.dart';

class HomeViewModel extends BaseModel {
  AuthenticationService _authenticationService;
  Api _api;

  HomeViewModel({
    @required AuthenticationService authenticationService,
    @required Api api,
  })  : _authenticationService = authenticationService,
        _api = api;

  void logOut(User user) async {
    print("homeviewmodel => logOut");
    setBusy(true);
    _authenticationService.logOut(user);
    setBusy(false);
    setError("");
  }

  List<User> friendRequests;
  Future findPendingFriendRequests(String userID) async {
    setBusy(true);
    friendRequests = await _api.findFriends(userID, "pending");
    setBusy(false);
  }
}
