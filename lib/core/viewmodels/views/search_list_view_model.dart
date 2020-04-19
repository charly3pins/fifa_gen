import 'package:fifagen/core/models/friendship.dart';
import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/services/api.dart';
import 'package:fifagen/core/viewmodels/base_model.dart';
import 'package:flutter/widgets.dart';

class SearchListViewModel extends BaseModel {
  Api _api;

  SearchListViewModel({
    @required Api api,
  }) : _api = api;

  List<User> _results = [];
  List<User> get results => _results;

  void clearUsers() {
    _results = [];
    notifyListeners();
  }

  Future findUsers(String query) async {
    print("findUsers $query");
    setBusy(true);
    _results = await _api.findUsers(query);
    setBusy(false);
    print("_results => $results");

    notifyListeners();
  }

  Future<Friendship> getFriendship(String userID, String otherUserID) async {
    print("getfriendship");
    setBusy(true);
    final friendship =
        await _api.getFriendship(userID, otherUserID); // TODO catch error
    setBusy(false);
    if (friendship.userOneID.isEmpty) {
      return null;
    }
    return friendship;
  }
}
