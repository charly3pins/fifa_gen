import 'package:fifagen/core/models/group.dart';
import 'package:fifagen/core/models/member.dart';
import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/services/api.dart';
import 'package:fifagen/core/viewmodels/base_model.dart';
import 'package:flutter/widgets.dart';

class GroupViewModel extends BaseModel {
  Api _api;

  GroupViewModel({
    @required Api api,
  }) : _api = api;

  List<Group> _groups = [];
  List<Group> get groups => _groups;

  List<User> _friends;
  List<User> get friends => _friends;

  List<Member> _selectedMembers = [];
  List<Member> get selectedMembers => _selectedMembers;
  void clearSelectedMembers() => _selectedMembers = [];

  Future findFriends(String userID) async {
    print("findfriends $userID");
    // setError(null);
    // setBusy(true);
    _friends = await _api.findFriends(userID, "friends");
    // setBusy(false);

    notifyListeners();
  }

  Future<bool> createGroup(Group group, Member loggedUser) async {
    setBusy(true);
    group.members.add(loggedUser);
    return await _api.createGroup(group).then((createdGroup) {
      print("createGroup => OK");
      setBusy(false);
      setError("");
      createdGroup.members = group.members;
      _groups.add(createdGroup); // add group to the groups list
      clearSelectedMembers();
      notifyListeners();
      return true;
    }).catchError((e) {
      print("createGroup => ERROR: $e");
      setBusy(false);
      setError(e);
      group.members.remove(loggedUser);

      notifyListeners();
      return false;
    });
  }

  Future findGroups(String userID) async {
    print("findGroups $userID");
    // setBusy(true);
    _groups = await _api.findGroups(userID);

    // setBusy(false);

    notifyListeners();
  }

  void addMember(Member member) {
    setError(null);
    setBusy(true);
    if (!isMember(member)) {
      _selectedMembers.add(member);
    } else {
      removeMember(member);
    }
    setBusy(false);

    notifyListeners();
  }

  void removeMember(Member member) {
    setError(null);
    setBusy(true);
    _selectedMembers.removeWhere((m) => m.id == member.id);
    setBusy(false);

    notifyListeners();
  }

  bool isMember(Member user) {
    for (var i = 0; i < _selectedMembers.length; i++) {
      if (_selectedMembers[i].id == user.id) {
        return true;
      }
    }

    return false;
  }
}
