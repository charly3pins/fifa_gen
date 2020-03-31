import 'package:fifagen/model/user.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    ListView(children: <Widget>[
      Card(
        child: ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Tottenham - Juventus")
        ),
      ),
      Card(
        child: ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("PSG - Liverpool")
        ),
      )
    ],
    ),
    ListView(children: <Widget>[
      Card(
        child: ListTile(
            leading: Icon(Icons.toys),
            title: Text("Challenge Covid")
        ),
      )
    ],
    ),
    ListView(children: <Widget>[
      Card(
        child: ListTile(
            leading: Icon(Icons.people),
            title: Text("Pollitas team")
        ),
      )
    ],
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person),
          tooltip: 'Profile',
          onPressed: () {
            String jsonString = '{"name": "gerry", "username": "cal_tit"}';
            Map<String, dynamic> user = json.decode(jsonString);
            Navigator.pushNamed(context, "/userprofile",
                arguments: User.fromJSON(user));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Notifications',
            onPressed: () {
              //scaffoldKey.currentState.showSnackBar(snackBar);
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              //openPage(context);
            },
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
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
