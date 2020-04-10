import 'package:fifagen/model/user.dart';
import 'package:fifagen/screen/groups.dart';
import 'package:fifagen/service/fifa_gen_api.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User _loggedUser;
  final String _genericAvatar = "avatar-default.png";
  int _notifications;

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    ListView(
      children: <Widget>[
        Card(
          child: ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Arsenal - Juventus (Challenge Covid)")),
        ),
        Card(
          child: ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("PSG - Liverpool  (Challenge Covid)")),
        )
      ],
    ),
    ListView(
      children: <Widget>[
        Card(
          child: ListTile(
              leading: Icon(Icons.toys),
              title: Text("Challenge Covid (Brothers team)")),
        )
      ],
    ),
    GroupsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNotificationsCounter() {
    if (_notifications != null && _notifications > 0){
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
              _notifications.toString(),
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ),
    );}
    return Container();
  }
  Widget _buildNotificationsIcon() {
    return Container(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Notifications',
            onPressed: () {},
            iconSize: 30,
          ),
          _buildNotificationsCounter(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      FifaGenAPI().getNotifications(_loggedUser.id).then((notifications) {
        _notifications = notifications;
      }).catchError((e) {
        // TODO improve this error check
        showDialog(
            context: context, builder: (_) => AlertDialog(title: Text(e)));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _loggedUser = ModalRoute.of(context).settings.arguments;

    return Stack(
      children: <Widget>[
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
            leading: IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/profile/" +
                        (_loggedUser.profilePicture != null &&
                                _loggedUser.profilePicture.isNotEmpty
                            ? _loggedUser.profilePicture
                            : _genericAvatar)),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(80.0),
                ),
              ),
              tooltip: 'My Profile',
              onPressed: () {
                Navigator.pushNamed(context, "/myprofile",
                    arguments: _loggedUser);
              },
            ),
            actions: <Widget>[
              _buildNotificationsIcon(),
              IconButton(
                icon: const Icon(Icons.search),
                iconSize: 30,
                tooltip: 'Search',
                onPressed: () {
                  Navigator.pushNamed(context, "/search",
                      arguments: _loggedUser);
                },
              ),
            ],
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                title: Text('Calendar'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.format_list_bulleted),
                title: Text('Tournaments'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                title: Text('Groups'),
              ),
            ],
            currentIndex: _selectedIndex,
            backgroundColor: Colors.transparent,
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.amberAccent,
            onTap: _onItemTapped,
          ),
        ),
      ],
    );
  }
}
