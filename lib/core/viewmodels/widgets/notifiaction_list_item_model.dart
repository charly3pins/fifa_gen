import 'package:fifagen/core/models/friendship.dart';
import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/services/api.dart';
import 'package:fifagen/core/services/notifications_service.dart';
import 'package:fifagen/core/viewmodels/base_model.dart';
import 'package:flutter/widgets.dart';

class NotificationListItemModel extends BaseModel {
  Api _api;
  NotificationsService _notificationsService;

  NotificationListItemModel({
    @required Api api,
    @required NotificationsService notificationsService,
  })  : _api = api,
        _notificationsService = notificationsService;

  List<User> friends;
  Future<bool> answerFriendRequest(Friendship friendship) async {
    setBusy(true);
    return await _api.updateFriendship(friendship).then((_) {
      print("answerFriendRequest => OK");
      setBusy(false);
      setError("");
      return true;
    }).catchError((e) {
      print("answerFriendRequest => ERROR: $e");
      setBusy(false);
      setError(e);
      return false;
    });
  }

  void removeReadNotification(User u) {
    setBusy(true);
    final int indxOf = _notificationsService.friendRequests.indexOf(u);
    _notificationsService.friendRequests.removeAt(indxOf);
    setBusy(false);
    setError("");
  }
}
