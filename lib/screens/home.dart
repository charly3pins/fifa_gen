import 'package:fifagen/models/user.dart';
import 'package:fifagen/notifiers/auth_api.dart';
import 'package:fifagen/screens/my_profile.dart';
import 'package:fifagen/screens/search_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Text("Matches"),
    Text("Tournaments"),
    Text("Groups"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _authNotif = Provider.of<AuthNotifier>(context);
    final User _user = _authNotif.user;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            width: 140.0,
            height: 140.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/profile/${_user.profilePicture}'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(80.0),
            ),
          ),
          tooltip: 'Profile',
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyProfileScreen()));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Notifications',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchListScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: 'Log out',
            onPressed: () {
              _authNotif.logout(_user);
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
            title: Text('Calendar'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            title: Text('Tournaments'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Groups'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
