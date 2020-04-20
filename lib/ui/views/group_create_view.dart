import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/viewmodels/views/group_view_model.dart';
import 'package:fifagen/ui/widgets/base_widget.dart';
import 'package:fifagen/ui/widgets/group_create_friend_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupCreateView extends StatefulWidget {
  @override
  _GroupCreateViewState createState() => _GroupCreateViewState();
}

class _GroupCreateViewState extends State<GroupCreateView> {
  @override
  Widget build(BuildContext context) {
    print("group view => BUILD");
    return BaseWidget<GroupViewModel>(
      model: GroupViewModel(
        api: Provider.of(context),
      ),
      onModelReady: (model) =>
          model.findFriends(Provider.of<User>(context, listen: false).id),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Column(
            children: <Widget>[
              Text("New group"),
              Text(
                model.selectedMembers.isEmpty
                    ? "Add members"
                    : "${model.selectedMembers.length.toString()} of ${model.friends.length.toString()} selected",
                style: TextStyle(fontSize: 15.0),
              ),
            ],
          ),
        ),
        body: _buildBody(context, model),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO check members have to be at least
            // TODO go to name selection
            //Navigator.pushNamed(context, RoutePaths.Group);
          },
          child: Icon(Icons.arrow_forward, color: Colors.black),
          backgroundColor: Colors.amberAccent,
        ),
      ),
    );
  }

  Widget _buildMembers(BuildContext context, GroupViewModel model) {
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
                        SizedBox(width: 50),
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
                onTap: () {
                  model.addMember(model.friends[index]);
                },
                isMember: model.isMember(model.friends[index]),
              ),
            ),
          );
  }

  Widget _buildBody(BuildContext context, GroupViewModel model) {
    return Column(children: <Widget>[
      _buildMembers(context, model),
      model.selectedMembers != null && model.selectedMembers.length > 0
          ? Divider(
              thickness: 1,
            )
          : Container(),
      _buildFriends(context, model)
    ]);
  }
}
