import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/services/api.dart';
import 'package:fifagen/core/viewmodels/base_model.dart';
import 'package:flutter/widgets.dart';

class GroupViewModel extends BaseModel {
  Api _api;

  GroupViewModel({
    @required Api api,
  }) : _api = api;

  List<User> _friends;
  List<User> get friends => _friends;

  List<User> _selectedMembers = [];
  List<User> get selectedMembers => _selectedMembers;

  Future findFriends(String userID) async {
    print("findfriends $userID");
    setBusy(true);
    _friends = await _api.findFriends(userID, "friends");
    setBusy(false);

    notifyListeners();
  }

  void addMember(User member) {
    setBusy(true);
    if (_selectedMembers.indexOf(member) == -1) {
      _selectedMembers.add(member);
    } else {
      removeMember(member);
    }
    setBusy(false);

    notifyListeners();
  }

  void removeMember(User member) {
    setBusy(true);
    _selectedMembers.remove(member);
    setBusy(false);

    notifyListeners();
  }

  bool isMember(User user) {
    return _selectedMembers.indexOf(user) > -1;
  }
}
