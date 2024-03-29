import 'package:fifagen/core/constants/app_constants.dart';
import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/viewmodels/views/home_view_model.dart';
import 'package:fifagen/ui/views/arguments/user_profile_view_arguments.dart';
import 'package:fifagen/ui/views/group_list_view.dart';
import 'package:fifagen/ui/views/notification_list_view.dart';
import 'package:fifagen/ui/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Text("Matches"),
    Text("Tournaments"),
    GroupListView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNotificationsCounter(int pendingRequestsLength) {
    if (pendingRequestsLength > 0) {
      return Container(
        width: 40,
        height: 40,
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 5),
        child: Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffc32c37),
              border: Border.all(color: Colors.white, width: 1)),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Center(
              child: Text(
                pendingRequestsLength.toString(),
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  Widget _buildNotificationsIcon(List<User> friendRequests) {
    return Container(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Notifications',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationListView()));
            },
            iconSize: 30,
          ),
          friendRequests != null
              ? _buildNotificationsCounter(friendRequests.length)
              : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("home_view => Build");
    // TODO check how to avoid the rebuilds bc of this
    var _user = Provider.of<User>(context);
    return _user == null
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : BaseWidget<HomeViewModel>(
            model: HomeViewModel(
                authenticationService: Provider.of(context),
                notificationsService: Provider.of(context)),
            onModelReady: (model) => {
                  model.setBusy(false),
                  model.findPendingFriendRequests(_user.id)
                },
            builder: (context, model, child) => Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Container(
                        width: 140.0,
                        height: 140.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/profile/${_user.profilePicture}'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(80.0),
                        ),
                      ),
                      tooltip: 'Profile',
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RoutePaths.UserProfile,
                          arguments: UserProfileViewArguments(
                              user: _user, friendship: null),
                        );
                      },
                    ),
                    actions: <Widget>[
                      _buildNotificationsIcon(model.friendRequests),
                      IconButton(
                        icon: const Icon(Icons.search),
                        tooltip: 'Search',
                        onPressed: () {
                          Navigator.pushNamed(context, RoutePaths.Search,
                              arguments: _user);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.exit_to_app),
                        tooltip: 'Log out',
                        onPressed: () {
                          model.logOut(_user);
                          Navigator.pop(context); // TODO CHECK THIS POP
                        },
                        iconSize: 30,
                      ),
                    ],
                  ),
                  body: Center(
                    child: _widgetOptions.elementAt(_selectedIndex),
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.calendar_today),
                        label: 'Calendar',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.format_list_bulleted),
                        label: 'Tournaments',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.people),
                        label: 'Groups',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                  ),
                ));
  }
}
