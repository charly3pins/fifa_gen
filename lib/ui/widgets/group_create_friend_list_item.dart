import 'package:fifagen/core/models/user.dart';
import 'package:flutter/material.dart';

class GroupCreateFriendListItem extends StatelessWidget {
  final User friend;
  final Function onTap;
  final bool isMember;
  const GroupCreateFriendListItem({this.friend, this.onTap, this.isMember});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Container(
            child: Stack(
          children: <Widget>[
            Container(
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/profile/" + friend.profilePicture),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(80.0),
              ),
            ),
            Container(
              width: 35,
              height: 35,
              alignment: Alignment.bottomRight,
              child: isMember
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 17,
                      ),
                      width: 20,
                      height: 20,
                    )
                  : Container(),
            ),
          ],
        )),
        title: Text(
          friend.username,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
