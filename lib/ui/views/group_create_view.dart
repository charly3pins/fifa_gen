import 'package:fifagen/core/models/group.dart';
import 'package:fifagen/core/models/member.dart';
import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/viewmodels/views/group_view_model.dart';
import 'package:fifagen/ui/widgets/base_widget.dart';
import 'package:fifagen/ui/widgets/group_create_friend_list_item.dart';
import 'package:fifagen/ui/widgets/snack_bar_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ViewMode { MEMBERS, DETAILS }

class GroupCreateView extends StatefulWidget {
  @override
  _GroupCreateViewState createState() => _GroupCreateViewState();
}

class _GroupCreateViewState extends State<GroupCreateView> {
  ViewMode _viewMode = ViewMode.MEMBERS;
  var _group = Group();
  final _createGroupFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    Provider.of<GroupViewModel>(context, listen: false)
        .findFriends(Provider.of<User>(context, listen: false).id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("group view => BUILD");

    final model = Provider.of<GroupViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (_viewMode == ViewMode.MEMBERS) {
              model.clearSelectedMembers();
              Navigator.pop(context);
            } else {
              setState(() {
                _viewMode = ViewMode.MEMBERS;
              });
            }
          },
        ),
        title: Column(
          children: <Widget>[
            Text("New group"),
            Text(
              _viewMode == ViewMode.MEMBERS
                  ? model.selectedMembers.isEmpty
                      ? "Add members"
                      : "${model.selectedMembers.length.toString()} of ${model.friends.length.toString()} selected"
                  : "Add name",
              style: TextStyle(fontSize: 15.0),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
      body: _viewMode == ViewMode.MEMBERS
          ? _buildAddMembersBody(context, model)
          : _buildAddDetailsBody(context, model),
      floatingActionButton: _viewMode == ViewMode.MEMBERS
          ? FloatingActionButton(
              onPressed: () {
                if (model.selectedMembers.isEmpty) {
                  model.setError("Select at least 1 member");
                } else {
                  setState(() {
                    _viewMode = ViewMode.DETAILS;
                  });
                }
              },
              child: Icon(Icons.arrow_forward, color: Colors.black),
              backgroundColor: Colors.amberAccent,
            )
          : FloatingActionButton(
              onPressed: () async {
                final form = _createGroupFormKey.currentState;
                if (form.validate()) {
                  form.save();
                  _group.members = model.selectedMembers;
                  final user = Provider.of<User>(context, listen: false);
                  // add user logged into selectedmembers before creating the group
                  final loggedUser = Member(
                      id: user.id,
                      name: user.name,
                      username: user.username,
                      profilePicture: user.profilePicture,
                      isAdmin: true);
                  var success = await model.createGroup(_group, loggedUser);
                  if (success) {
                    print("success $success");
                    form.reset();
                    _group = Group();
                    Navigator.pop(context);
                  } else {
                    _group.members.remove(loggedUser);
                  }
                }
              },
              child: Icon(Icons.check, color: Colors.black),
              backgroundColor: Colors.amberAccent,
            ),
    );
  }

  Widget _buildSelectedMembers(BuildContext context, GroupViewModel model) {
    return model.selectedMembers == null || model.selectedMembers.isEmpty
        ? Container()
        : Container(
            margin: const EdgeInsets.only(left: 5.0, top: 5.0),
            child: Row(
              children: <Widget>[
                for (var member in model.selectedMembers)
                  GestureDetector(
                    onTap: () {
                      model.removeMember(member);
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/profile/" +
                                        member.profilePicture),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(80.0),
                                ),
                              ),
                              Container(
                                width: 45,
                                height: 45,
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey,
                                  ),
                                  child: Icon(
                                    Icons.clear,
                                    size: 17,
                                  ),
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          member.username,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
  }

  Widget _buildFriends(BuildContext context, GroupViewModel model) {
    return model.friends == null || model.friends.isEmpty
        ? Container()
        : Expanded(
            child: ListView.builder(
              itemCount: model.friends.length,
              itemBuilder: (context, index) => GroupCreateFriendListItem(
                friend: model.friends[index],
                isMember: model.isMember(
                  Member(
                      id: model.friends[index].id,
                      name: model.friends[index].name,
                      username: model.friends[index].username,
                      profilePicture: model.friends[index].profilePicture,
                      isAdmin: false),
                ),
                onTap: () {
                  model.addMember(
                    Member(
                        id: model.friends[index].id,
                        name: model.friends[index].name,
                        username: model.friends[index].username,
                        profilePicture: model.friends[index].profilePicture,
                        isAdmin: false),
                  );
                },
              ),
            ),
          );
  }

  Widget _buildAddMembersBody(BuildContext context, GroupViewModel model) {
    return Column(children: <Widget>[
      _buildSelectedMembers(context, model),
      model.selectedMembers != null && model.selectedMembers.length > 0
          ? Divider(thickness: 1)
          : Container(),
      _buildFriends(context, model),
      model.error != null && model.error.isNotEmpty
          ? SnackBarLauncher(error: model.error)
          : Container(),
    ]);
  }

  Widget _buildAddDetailsBody(BuildContext context, GroupViewModel model) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 10.0),
          child: Form(
            key: _createGroupFormKey,
            child: TextFormField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Add name...",
                  hintStyle: TextStyle(color: Colors.grey)),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the Group name.';
                }
                return null;
              },
              onSaved: (val) => setState(() => _group.name = val.trim()),
            ),
          ),
        ),
        Divider(thickness: 1),
        Container(
          margin: const EdgeInsets.only(left: 10.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child:
                    Text("Members: ${model.selectedMembers.length.toString()}"),
              ),
              SizedBox(height: 10),
              Row(children: <Widget>[
                for (var member in model.selectedMembers)
                  Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 3.0),
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/profile/" + member.profilePicture),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(80.0),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 3.0),
                        child: Text(
                          member.username,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
              ]),
            ],
          ),
        ),
        model.error != null && model.error.isNotEmpty
            ? SnackBarLauncher(error: model.error)
            : Container(),
      ],
    );
  }
}
