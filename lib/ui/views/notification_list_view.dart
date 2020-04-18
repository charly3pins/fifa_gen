import 'package:fifagen/core/constants/app_constants.dart';
import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/ui/widgets/notification_list_item.dart';
import 'package:flutter/material.dart';

class NotificationListView extends StatelessWidget {
  final List<User> friendRequests;
  const NotificationListView({this.friendRequests});

  @override
  Widget build(BuildContext context) {
    print("notification_list_vieww => Build");
    return Scaffold(
      appBar: AppBar(),
      body: friendRequests == null
          ? Center(
              child: Text("No pending notifications"),
            )
          : ListView.builder(
              itemCount: friendRequests.length,
              itemBuilder: (context, index) => NotificationListItem(
                friendRequest: friendRequests[index],
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RoutePaths.UserProfile,
                    arguments: friendRequests[index],
                  );
                },
              ),
            ),
    );
  }
}
