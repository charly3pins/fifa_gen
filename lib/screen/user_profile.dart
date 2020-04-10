import 'package:fifagen/model/friend.dart';
import 'package:fifagen/model/user.dart';
import 'package:fifagen/service/fifa_gen_api.dart';
import 'package:flutter/material.dart';

enum RequestState { ACCEPTED, PENDING, REQUESTED }

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreen createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  List<User> _argUsers;
  User _loggedUser;
  User _profileUser;
  RequestState _requestState;

  final String _genericAvatar = "avatar-default.png";

  final String _friends = "16";
  final String _scores = "450";

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
            image: AssetImage("assets/profile/" +
                (_profileUser.profilePicture != null &&
                        _profileUser.profilePicture.isNotEmpty
                    ? _profileUser.profilePicture
                    : _genericAvatar)),
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
      _profileUser.name + " (" + _profileUser.username + ")",
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
          _buildStatItem("Scores", _scores),
        ],
      ),
    );
  }

  // TODO add option for UNFOLLOW
  Widget _buildAccepted() {
    return Expanded(
      child: InkWell(
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            border: Border.all(),
            color: Color(0xFFEFF4F7),
          ),
          child: Center(
            child: Text(
              "FOLLOWING",
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFollow() {
    return Expanded(
      child: InkWell(
        onTap: () {
          Friend friend = Friend(
              id: "",
              receiver: _profileUser.id,
              sender: _loggedUser.id,
              state: "REQUESTED");
          FifaGenAPI().sendFriendRequest(friend).then((friendRequest) {
            setState(() {
              _requestState = RequestState.REQUESTED;
              showDialog(
                  context: context,
                  builder: (_) =>
                      // TODO improve
                      AlertDialog(title: Text("Friend request sent.")));
            });
          }).catchError((e) {
            // TODO improve this error check
            showDialog(
                context: context, builder: (_) => AlertDialog(title: Text(e)));
          });
        },
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            border: Border.all(),
            color: Color(0xFF404A5C),
          ),
          child: Center(
            child: Text(
              "FOLLOW",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequested() {
    return Expanded(
      child: InkWell(
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            border: Border.all(),
            color: Color(0xFFEFF4F7),
          ),
          child: Center(
            child: Text(
              "REQUESTED...",
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessage() {
    return Expanded(
      child: InkWell(
        onTap: () => print("Message"),
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            border: Border.all(),
            color: Color(0xFFEFF4F7),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "MESSAGE",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStateButton() {
    switch (_requestState) {
      case RequestState.ACCEPTED:
        return _buildAccepted();
      case RequestState.REQUESTED:
        return _buildRequested();
      case RequestState.PENDING:
      default:
        return _buildFollow();
    }
  }

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          _buildStateButton(),
          SizedBox(width: 10.0),
          _buildMessage(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Friend friend = Friend(
        receiver: _profileUser.id,
        sender: _loggedUser.id,
      );
      FifaGenAPI().getFriendship(friend).then((friendRequest) {
        setState(() {
          switch (friendRequest.state) {
            case "ACCEPTED":
              _requestState = RequestState.ACCEPTED;
              break;
            case "PENDING":
              _requestState = RequestState.PENDING;
              break;
            case "REQUESTED":
              _requestState = RequestState.REQUESTED;
              break;
            default:
              _requestState = RequestState.PENDING;
          }
        });
      }).catchError((e) {
        // TODO improve this error check
        showDialog(
            context: context, builder: (_) => AlertDialog(title: Text(e)));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _argUsers = ModalRoute.of(context).settings.arguments;
    _loggedUser = _argUsers[0];
    _profileUser = _argUsers[1];

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
                      _buildButtons(),
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
