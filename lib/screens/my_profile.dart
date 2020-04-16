import 'package:fifagen/models/user.dart';
import 'package:fifagen/notifiers/auth_api.dart';
import 'package:fifagen/notifiers/errors.dart';
import 'package:fifagen/widgets/snack_bar_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ViewMode { EDIT, READ }

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfileScreen> {
  ViewMode _viewMode = ViewMode.READ;

  final _editUser = User();
  final _formKey = GlobalKey<FormState>();

  Widget _buildProfileImage(User user) {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/profile/" + user.profilePicture),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _authNotif = Provider.of<AuthNotifier>(context);
    final User _user = _authNotif.user;

    if (_viewMode == ViewMode.EDIT) {
      return _buildEdit(context, _user, _authNotif);
    } else {
      _authNotif.clearError();
      return _buildRead(context, _user);
    }
  }

  Widget _buildEdit(BuildContext context, User user, AuthNotifier authNotif) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit profile"),
          leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _viewMode = ViewMode.READ;
              });
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                final form = _formKey.currentState;
                if (form.validate()) {
                  authNotif.clearError();
                  form.save();
                  authNotif.updateUser(user).then((_) {
                    user.name = _editUser.name;
                    setState(() {
                      _viewMode = ViewMode.READ;
                    });
                  }).catchError((_) {
                    authNotif.set(ErrorUpdateUserProfile);
                  });
                }
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {},
                    textColor: Colors.black,
                    child: _buildProfileImage(user),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Name", hasFloatingPlaceholder: true),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Name.';
                      }
                      return null;
                    },
                    initialValue: user.name,
                    onSaved: (val) =>
                        setState(() => _editUser.name = val.trim()),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
            Consumer<AuthNotifier>(
              builder: (context, authNotif, child) =>
                  SnackBarLauncher(error: authNotif.error),
            ),
          ],
        ));
  }

  Widget _buildRead(BuildContext context, User user) {
    // Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new AppBar(
        title: Text(user.username),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            // TODO implement settings page
            onPressed: () {
              setState(() {
                _viewMode = ViewMode.EDIT;
              });
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          _buildProfileImage(user),
          SizedBox(height: 10.0),
          Text(
            user.name,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
