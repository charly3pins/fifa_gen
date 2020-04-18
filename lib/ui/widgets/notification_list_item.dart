import 'package:fifagen/core/constants/app_constants.dart';
import 'package:fifagen/core/models/friendship.dart';
import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/viewmodels/widgets/notifiaction_list_item_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_widget.dart';

class NotificationListItem extends StatelessWidget {
  final User friendRequest;
  final Function onTap;
  const NotificationListItem({this.friendRequest, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          child: ListTile(
        leading: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage("assets/profile/" + friendRequest.profilePicture),
            ),
            borderRadius: BorderRadius.circular(100.0),
          ),
        ),
        title: Text(
          friendRequest.username,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Row(
          children: <Widget>[
            BaseWidget<NotificationListItemModel>(
                model: NotificationListItemModel(
                    api: Provider.of(context),
                    notificationsService: Provider.of(context)),
                builder: (context, model, child) => FlatButton(
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
                      onPressed: () async {
                        // The pending requests will be from the other user,
                        // so the logged user will be the userTwo and the actionUser always
                        final friendship = Friendship(
                            userOneID: friendRequest.id,
                            userTwoID:
                                Provider.of<User>(context, listen: false).id,
                            status: FriendshipStatusCode.Accepted,
                            actionUserID:
                                Provider.of<User>(context, listen: false).id);
                        var success =
                            await model.answerFriendRequest(friendship);
                        if (success) {
                          model.removeReadNotification(friendRequest);
                          Navigator.pop(context);
                        }
                      },
                    )),
            SizedBox(width: 10.0),
            BaseWidget<NotificationListItemModel>(
              model: NotificationListItemModel(
                  api: Provider.of(context),
                  notificationsService: Provider.of(context)),
              builder: (context, model, child) => FlatButton(
                child: Text("Delete",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
                color: Colors.white,
                textColor: Colors.black,
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () async {
                  // The pending requests will be from the other user,
                  // so the logged user will be the userTwo and the actionUser always
                  final friendship = Friendship(
                      userOneID: friendRequest.id,
                      userTwoID: Provider.of<User>(context, listen: false).id,
                      status: FriendshipStatusCode.Declined,
                      actionUserID:
                          Provider.of<User>(context, listen: false).id);
                  var success = await model.answerFriendRequest(friendship);
                  if (success) {
                    model.removeReadNotification(friendRequest);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
