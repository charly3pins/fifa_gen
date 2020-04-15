import 'package:fifagen/model/friendship.dart';
import 'package:fifagen/model/user.dart';
import 'package:fifagen/service/fifa_gen_api.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  get updateFriendRequests => _NotificationsState()._updateFriendRequests;

  @override
  _NotificationsState createState() => _NotificationsState();
}

class NotificationsScreenArguments {
  final User loggedUser;
  final List<User> friendRequests;

  NotificationsScreenArguments(this.loggedUser, this.friendRequests);
}

class _NotificationsState extends State<NotificationsScreen> {
  NotificationsScreenArguments _args;
  User _loggedUser;
  List<User> _friendRequests;

  _updateFriendRequests(Friendship f) {
    setState(() {
      _friendRequests.remove(f);
    });
  }

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute
        .of(context)
        .settings
        .arguments;
    _loggedUser = _args.loggedUser;
    _friendRequests = _args.friendRequests;

    return Stack(children: <Widget>[
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/fifa-20-bg.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body: ListView.builder(
            itemCount: _friendRequests.length,
            itemBuilder: (BuildContext context, int index) {
              var user = _friendRequests[index];
              return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/userprofile",
                        arguments: [_loggedUser, user]);
                  },
                  child: Card(
                      child: ListTile(
                        leading: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/profile/" + user.profilePicture),
                            ),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                        title: Text(
                          user.username,
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            FlatButton(
                              child: Text("Confirm",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  )),
                              color: Color(0xFF4B9DFE),
                              textColor: Colors.white,
                              padding: EdgeInsets.only(
                                  left: 30, right: 30, top: 10, bottom: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              onPressed: () {
                                Friendship friendship = Friendship(
                                    userOneID: user.id,
                                    userTwoID: _loggedUser
                                        .id,
                                    // The pending requests will be from the user.id, so the loggedUser will be the userTwo always
                                    status: FriendshipStatus.Accepted,
                                    actionUserID: _loggedUser.id);
                                FifaGenAPI()
                                    .answerFriendRequest(friendship)
                                    .then((resp) {
                                  setState(() {
                                    _friendRequests.remove(user);
                                    Navigator.pushNamed(context, "/userprofile",
                                        arguments: [_loggedUser, user]);
                                  });
                                }).catchError((e) {
                                  // TODO improve this error check
                                  showDialog(
                                      context: context,
                                      builder: (_) =>
                                          AlertDialog(
                                              title: Text(e.toString())));
                                });
                              },
                            ),
                            SizedBox(width: 10.0),
                            FlatButton(
                              child: Text("Delete",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  )),
                              color: Colors.white,
                              textColor: Colors.black,
                              padding: EdgeInsets.only(
                                  left: 30, right: 30, top: 10, bottom: 10),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5)),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      )));
            },
          ))
    ]);
  }
}