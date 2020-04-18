import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/services/authentication_service.dart';
import 'package:fifagen/core/services/notifications_service.dart';
import 'package:fifagen/core/viewmodels/base_model.dart';
import 'package:flutter/widgets.dart';

class HomeViewModel extends BaseModel {
  AuthenticationService _authenticationService;
  NotificationsService _notificationsService;

  HomeViewModel({
    @required AuthenticationService authenticationService,
    @required NotificationsService notificationsService,
  })  : _authenticationService = authenticationService,
        _notificationsService = notificationsService;

  void logOut(User user) async {
    print("homeviewmodel => logOut");
    setBusy(true);
    _authenticationService.logOut(user);
    setBusy(false);
    setError("");
  }

  Future<bool> findPendingFriendRequests(String userID) async {
    print("homeviewmodel => findpendingfriendrequests");
    setBusy(true);
    return await _notificationsService
        .findPendingFriendRequests(userID)
        .then((success) {
      print("homeviewmodel => OK");
      setBusy(false);
      setError("");
      return success;
    }).catchError((e) {
      print("homeviewmodel => ERROR: $e");
      setBusy(false);
      setError(e);
      return false;
    });
  }

  List<User> getFriendRequests() => _notificationsService.friendRequests;
}
