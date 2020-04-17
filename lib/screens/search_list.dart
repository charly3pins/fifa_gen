import 'package:fifagen/models/user.dart';
import 'package:fifagen/notifiers/auth_api.dart';
import 'package:fifagen/notifiers/errors.dart';
import 'package:fifagen/notifiers/users_api.dart';
import 'package:fifagen/screens/user_profile.dart';
import 'package:fifagen/widgets/snack_bar_launcher.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SearchListScreen extends StatefulWidget {
  SearchListScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchState();
}

class _SearchState extends State<SearchListScreen> {
  final FocusNode myFocusNode = new FocusNode();

  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();

  _SearchState() {
    _searchQuery.addListener(() {
      // TODO check how to improve this method
      if (this.mounted) {
        final _usersNotif = Provider.of<UsersNotifier>(context, listen: false);
        var query = _searchQuery.text;

        if (query.isEmpty) {
          _usersNotif.clearUsers();
          return;
        }

        _usersNotif.clearError();
        _usersNotif.findUsers(query).catchError((_) {
          _usersNotif.setError(ErrorFindingUsers);
        });
        ;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _usersNotif = Provider.of<UsersNotifier>(context);
    final _users = _usersNotif.users;
    final _error = _usersNotif.error;

    // TODO improve this remove of the logged user
    final _user = Provider.of<AuthNotifier>(context).user;
    for (var i = 0; i < _users.length; i++) {
      if (_users[i].id == _user.id) {
        _users.removeAt(i);
        break;
      }
    }
    return Scaffold(
        key: key,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
        body: buildBody(context, _searchQuery.text, _error, _users));
  }

  Widget buildBody(
      BuildContext context, String query, String error, List<User> users) {
    if (error != null) {
      return Container(
        child: Consumer<UsersNotifier>(
          builder: (context, authNotif, child) =>
              SnackBarLauncher(error: authNotif.error),
        ),
      );
    } else if (query.isNotEmpty && users.length == 0) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Text(
            NoResultsFoundFor + '"$query"',
            textAlign: TextAlign.center,
          ));
    } else {
      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            var user = users[index];
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfileScreen(
                                user: user,
                              )));
                },
                child: Card(
                    child: ListTile(
                  leading: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage("assets/profile/" + user.profilePicture),
                      ),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  title: Text(
                    user.username,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(user.name),
                )));
          });
    }
  }
}
