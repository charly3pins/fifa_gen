import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/services/api.dart';

class NotificationsService {
  final Api _api;

NotificationsService({Api api}) : _api = api;
  List<User> _friendRequests;

  List<User> get friendRequests => _friendRequests;

  Future<bool> findPendingFriendRequests(String userID) async {
    print("NotificationsService => findpendingfriendrequests");
    return await _api.findFriends(userID, "pending").then((reqs) {
      _friendRequests = reqs;
      print("NotificationsService => OK");
      return true;
    }).catchError((e) {
      print("NotificationsService => ERROR: $e");
      throw (e);
    });
  }

}