import 'package:fifagen/notifiers/users_api.dart';
import 'package:fifagen/widgets/snack_bar_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationListScreen extends StatelessWidget {
  Widget _build(BuildContext context, UsersNotifier usersNotif) {
    final _users = usersNotif.users;

    return Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (BuildContext context, int index) {
            var user = _users[index];
            return GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, "/userprofile",
                  //     arguments: [_loggedUser, user]);
                },
                child: Card(
                    child: ListTile(
                  leading: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage("assets/profile/" + user.profilePicture),
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
                          // Friendship friendship = Friendship(
                          //     userOneID: user.id,
                          //     userTwoID: _loggedUser.id,
                          //     // The pending requests will be from the user.id, so the loggedUser will be the userTwo always
                          //     status: FriendshipStatus.Accepted,
                          //     actionUserID: _loggedUser.id);
                          // FifaGenAPI()
                          //     .answerFriendRequest(friendship)
                          //     .then((resp) {
                          //   setState(() {
                          //     _friendRequests.remove(user);
                          //     Navigator.pushNamed(context, "/userprofile",
                          //         arguments: [_loggedUser, user]);
                          //   });
                          // }).catchError((e) {
                          //   // TODO improve this error check
                          //   showDialog(
                          //       context: context,
                          //       builder: (_) =>
                          //           AlertDialog(title: Text(e.toString())));
                          // });
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
                      Consumer<UsersNotifier>(
                        builder: (context, usersNotif, child) =>
                            SnackBarLauncher(error: usersNotif.error),
                      ),
                    ],
                  ),
                )));
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    print("build notif");
    final _usersNotif = Provider.of<UsersNotifier>(context);

    return _build(context, _usersNotif);
  }
}
