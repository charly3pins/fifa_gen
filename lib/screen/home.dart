import 'package:fifagen/model/user.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User loggedUser;

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    ListView(children: <Widget>[
      Card(
        child: ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Arsenal - Juventus (Challenge Covid)")
        ),
      ),
      Card(
        child: ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("PSG - Liverpool  (Challenge Covid)")
        ),
      )
    ],
    ),
    ListView(children: <Widget>[
      Card(
        child: ListTile(
            leading: Icon(Icons.toys),
            title: Text("Challenge Covid (Brothers team)")
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
    loggedUser = ModalRoute.of(context).settings.arguments;

    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: new BoxDecoration(
            color: Colors.black,
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
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/law-mustache-thumb.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(80.0),
                ),
              ),
              tooltip: 'Profile',
              onPressed: () {
                Navigator.pushNamed(context, "/userprofile",
                    arguments: loggedUser);
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
              backgroundColor: Colors.transparent ,
              unselectedItemColor: Colors.white,
              selectedItemColor: Colors.amberAccent,
              onTap: _onItemTapped,
            ),
        ),
      ],
    );
  }
}
