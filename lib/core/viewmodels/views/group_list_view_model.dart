import 'package:fifagen/core/models/group.dart';
import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/services/api.dart';
import 'package:fifagen/core/viewmodels/base_model.dart';
import 'package:flutter/widgets.dart';

class GroupListViewModel extends BaseModel {
  Api _api;

  GroupListViewModel({
    @required Api api,
  }) : _api = api;

  List<Group> _groups;

  List<Group> get groups => _groups;

  Future findGroups(String userID) async {
    print("findGroups $userID");
    setBusy(true);
    // TODO uncomment when API is available _groups = await _api.findGroups(userID);

    var members = List<User>();
    members.add(User(
        id: "1",
        name: "Carles",
        username: "charly",
        profilePicture: "man.png"));
    members.add(User(
        id: "2",
        name: "Cristina",
        username: "crispi",
        profilePicture: "woman.png"));
    _groups = List<Group>();
    _groups.add(Group(id: "test-1", name: "Covid friends", members: members));

    setBusy(false);
    print("_groups => $groups");

    notifyListeners();
  }
}
