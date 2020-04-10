import 'package:fifagen/model/user.dart';
import 'package:fifagen/service/fifa_gen_api.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class SearchListScreen extends StatefulWidget {
  SearchListScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchState();
}

class _SearchState extends State<SearchListScreen> {
  User _loggedUser;
  final String _genericAvatar = "avatar-default.png";

  final FocusNode myFocusNode = new FocusNode();

  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  bool _isSearching = false;
  String _error;
  List<User> _results = List();

  Timer debounceTimer;

  _SearchState() {
    _searchQuery.addListener(() {
      if (debounceTimer != null) {
        debounceTimer.cancel();
      }
      debounceTimer = Timer(Duration(milliseconds: 500), () {
        if (this.mounted) {
          performSearch(_searchQuery.text);
        }
      });
    });
  }

  void performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _error = null;
        _results = List();
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
      _results = List();
    });

    final users = await FifaGenAPI().findUsers(query);
    // TODO improve this remove of the logged user
    for (var i = 0; i < users.length; i++) {
      if (users[i].id == _loggedUser.id) {
        users.removeAt(i);
        break;
      }
    }

    if (this._searchQuery.text == query && this.mounted) {
      setState(() {
        _isSearching = false;
        if (users != null) {
          _results = users;
        } else {
          _error = 'Error searching users';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _loggedUser = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        key: key,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: TextField(
            autofocus: true,
            controller: _searchQuery,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search users...",
                hintStyle: TextStyle(color: Colors.white)),
          ),
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    if (_isSearching) {
      return CenterTitle('Searching users...');
    } else if (_error != null) {
      return CenterTitle(_error);
    } else {
      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          itemCount: _results.length,
          itemBuilder: (BuildContext context, int index) {
            var user = _results[index];

            return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/userprofile", arguments: user);
                },
                child: Card(
                    child: ListTile(
                  leading: IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/profile/" +
                              (user.profilePicture != null &&
                                      user.profilePicture.isNotEmpty
                                  ? user.profilePicture
                                  : _genericAvatar)),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                  ),
                  title: Text(user.username),
                  subtitle: Text(user.name),
                  //trailing: Icon(Icons.keyboard_arrow_right),
                )));
          });
    }
  }
}

class CenterTitle extends StatelessWidget {
  final String title;

  CenterTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        alignment: Alignment.center,
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline,
          textAlign: TextAlign.center,
        ));
  }
}
