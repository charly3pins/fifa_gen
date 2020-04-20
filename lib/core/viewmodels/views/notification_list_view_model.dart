import 'package:fifagen/core/models/friendship.dart';
import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/services/api.dart';
import 'package:fifagen/core/services/notifications_service.dart';
import 'package:fifagen/core/viewmodels/base_model.dart';
import 'package:flutter/widgets.dart';

class NotificationListViewModel extends BaseModel {
  Api _api;
  NotificationsService _notificationsService;

  NotificationListViewModel({
    @required Api api,
    @required NotificationsService notificationsService,
  })  : _api = api,
        _notificationsService = notificationsService;

  List<User> _friendRequests;

  List<User> get friendRequests => _friendRequests;
    

  Future<bool> findPendingFriendRequests(String userID) async {
    print("notificationlistviewmodel => findpendingfriendrequests");
    setBusy(true);
    return await _notificationsService
        .findPendingFriendRequests(userID)
        .then((success) {
      print("notificationlistviewmodel => OK");
      setBusy(false);
      setError("");
       _friendRequests = _notificationsService.friendRequests;
      notifyListeners();
      return true;
    }).catchError((e) {
      print("notificationlistviewmodel => ERROR: $e");
      setBusy(false);
      setError(e);
      notifyListeners();
      return false;
    });
  }

  Future<bool> answerFriendRequest(Friendship friendship) async {
    setBusy(true);
    return await _api.updateFriendship(friendship).then((_) {
      print("answerFriendRequest => OK");
      setBusy(false);
      setError("");
      notifyListeners();
      return true;
    }).catchError((e) {
      print("answerFriendRequest => ERROR: $e");
      setBusy(false);
      setError(e);
      notifyListeners();
      return false;
    });
  }

  void removeReadNotification(User u) {
    print("_notificationsService.friendRequests => ${_notificationsService.friendRequests}");
    print("_friendRequests => $_friendRequests");
    setBusy(true);
    _notificationsService.friendRequests.remove(u);
    //_friendRequests.remove(u);
    setBusy(false);
    setError("");
    notifyListeners();
  }
}
