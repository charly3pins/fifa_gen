import 'package:fifagen/model/user.dart';
import 'package:flutter/material.dart';

enum ViewMode { EDIT, READ }

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfileScreen> {
  // Set initial mode to READ
  ViewMode _viewMode = ViewMode.READ;

  User _loggedUser;
  User _editUser;

  final String _friends = "16";
  final String _scores = "450";

  final _myProfileFormKey = GlobalKey<FormState>();

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 3.5,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/fifa-20-bg.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/profile/" + _loggedUser.profilePicture),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      _loggedUser.name,
      style: _nameTextStyle,
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildStatContainer() {
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Friends", _friends),
          //_buildStatItem("Posts", _posts),
          _buildStatItem("Scores", _scores),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _loggedUser = ModalRoute.of(context).settings.arguments;

    if (_viewMode == ViewMode.EDIT) {
      return edit(context);
    } else {
      return read(context);
    }
  }

  Widget edit(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
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
              title: Text("Edit profile"),
              backgroundColor: Colors.black,
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
                    final form = _myProfileFormKey.currentState;
                    if (form.validate()) {
                      form.save();
                    }
                  },
                )
              ],
            ),
            body: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: _myProfileFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              // TODO
                              /*
                              GridView.builder(
                                shrinkWrap: true,
                                itemCount: programmeList.length,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 0.7,
                                ),
                                itemBuilder: (context, index) {
                                  return Programme(data: programmeList[index]);
                                },
                              )
                              */
                            },
                            textColor: Colors.black,
                            child: _buildProfileImage(),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Name",
                                hasFloatingPlaceholder: true),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your Name.';
                              }
                              return null;
                            },
                            initialValue: _loggedUser.name,
                            onSaved: (val) =>
                                setState(() => _editUser.name = val.trim()),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    )))),
      ],
    );
  }

  Widget read(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
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
          appBar: new AppBar(
            backgroundColor: Colors.transparent,
            title: Text(_loggedUser.username),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                // TODO implement settings page
                onPressed: () {
                  setState(() {
                    _viewMode = ViewMode.EDIT;
                  });
                },
              )
            ],
          ),
          body: Stack(
            children: <Widget>[
              _buildCoverImage(screenSize),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _buildProfileImage(),
                      SizedBox(height: 10.0),
                      _buildFullName(),
                      SizedBox(height: 30.0),
                      _buildStatContainer(),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
