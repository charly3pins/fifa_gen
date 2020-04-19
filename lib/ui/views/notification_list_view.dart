import 'package:fifagen/core/constants/app_constants.dart';
import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/viewmodels/views/notification_list_view_model.dart';
import 'package:fifagen/ui/views/arguments/user_profile_view_arguments.dart';
import 'package:fifagen/ui/widgets/base_widget.dart';
import 'package:fifagen/ui/widgets/notification_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("notification_list_vieww => Build");
    return BaseWidget<NotificationListViewModel>(
      model: NotificationListViewModel(
        api: Provider.of(context),
        notificationsService: Provider.of(context),
      ),
      onModelReady: (model) => model.findPendingFriendRequests(
          Provider.of<User>(context, listen: false).id),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(),
        body: model.friendRequests == null || model.friendRequests.isEmpty
            ? Center(
                child: Text("No pending notifications"),
              )
            : ListView.builder(
                itemCount: model.friendRequests.length,
                itemBuilder: (context, index) => NotificationListItem(
                  friendRequest: model.friendRequests[index],
                  onTap: () {
                    Navigator.pushNamed(context, RoutePaths.UserProfile,
                        arguments: UserProfileViewArguments(
                            user: model.friendRequests[index],
                            friendshipStatus: FriendshipStatusCode.Requested));
                  },
                ),
              ),
      ),
    );
  }
}
