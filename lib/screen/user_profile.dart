import 'package:fifagen/model/friendship.dart';
import 'package:fifagen/model/user.dart';
import 'package:fifagen/service/fifa_gen_api.dart';
import 'package:flutter/material.dart';

enum RequestState { ACCEPTED, PENDING, DECLINED, BLOCKED }

class UserProfileScreen extends StatefulWidget {
  final void Function(Friendship f) parentAction;

  const UserProfileScreen({Key key, this.parentAction}) : super(key: key);

  @override
  _UserProfileScreen createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  List<User> _argUsers;
  User _loggedUser;
  User _visitedUserProfile;
  RequestState _requestState;
  Friendship _friendship;

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
            image: AssetImage(
                "assets/profile/" + _visitedUserProfile.profilePicture),
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
      _visitedUserProfile.name,
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

  // TODO add option for remove
  Widget _buildAccepted() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.person),
          SizedBox(width: 5),
          Text(
            "Friends",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
      padding: EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
    );
  }

  Widget _buildRequested() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.person),
          SizedBox(width: 5),
          Text(
            "Request sent",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
      padding: EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
    );
  }

  Widget _buildAddFriend() {
    return FlatButton(
      color: Color(0xFF4B9DFE),
      textColor: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.person_add),
          SizedBox(width: 5),
          Text(
            "Add friend",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
      padding: EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      onPressed: () {
        Friendship friendship = Friendship(
            userOneID: _loggedUser.id,
            userTwoID: _visitedUserProfile.id,
            status: FriendshipStatus.Pending,
            actionUserID: _loggedUser.id);
        FifaGenAPI().createFriendRequest(friendship).then((friendRequest) {
          setState(() {
            _requestState = RequestState.PENDING;
            _friendship = friendRequest;
          });
        }).catchError((e) {
          // TODO improve this error check
          showDialog(
              context: context, builder: (_) => AlertDialog(title: Text(e)));
        });
      },
    );
  }

  Widget _buildAnswerRequestButtons() {
    return Row(
      children: <Widget>[
        FlatButton(
          child: Text("Confirm",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              )),
          color: Color(0xFF4B9DFE),
          textColor: Colors.white,
          padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onPressed: () {
            // The pending requests will be from the _visitedUserProfile.id,
            // so the _loggedUser will be the userTwo always
            Friendship friendship = Friendship(
                userOneID: _visitedUserProfile.id,
                userTwoID: _loggedUser.id,
                status: FriendshipStatus.Accepted,
                actionUserID: _loggedUser.id);
            FifaGenAPI().answerFriendRequest(friendship).then((resp) {
              friendship.actionUserID = _visitedUserProfile.id;
              friendship.status = FriendshipStatus.Pending;
              widget.parentAction(friendship);
              setState(() {
                _requestState = RequestState.ACCEPTED;
              });
            }).catchError((e) {
              // TODO improve this error check
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(title: Text(e.toString())));
            });
          },
        ),
        SizedBox(width: 10.0),
        FlatButton(
          child: Text("Delete",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              )),
          color: Colors.white,
          textColor: Colors.black,
          padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(5)),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildStateButton() {
    switch (_requestState) {
      case RequestState.ACCEPTED:
        return _buildAccepted();
      case RequestState.PENDING:
        if (_friendship.actionUserID != _loggedUser.id) {
          return _buildAnswerRequestButtons();
        }
        return _buildRequested();
      // TODO add DECLINED and BLOCKED
      default:
        return _buildAddFriend();
    }
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildStateButton(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Friendship friendship = Friendship(
        userOneID: _loggedUser.id,
        userTwoID: _visitedUserProfile.id,
      );
      FifaGenAPI().getFriendship(friendship).then((friendRequest) {
        setState(() {
          if (friendRequest == null) {
            _requestState = null;
            _friendship = null;
          } else {
            switch (friendRequest.status) {
              case FriendshipStatus.Pending:
                _requestState = RequestState.PENDING;
                break;
              case FriendshipStatus.Accepted:
                _requestState = RequestState.ACCEPTED;
                break;
              case FriendshipStatus.Declined:
                _requestState = RequestState.DECLINED;
                break;
              case FriendshipStatus.Blocked:
                _requestState = RequestState.BLOCKED;
                break;
              default:
                _requestState = null;
            }
            _friendship = friendRequest;
          }
        });
      }).catchError((e) {
        // TODO improve this error check
        showDialog(
            context: context,
            builder: (_) => AlertDialog(title: Text(e.toString())));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _argUsers = ModalRoute.of(context).settings.arguments;
    _loggedUser = _argUsers[0];
    _visitedUserProfile = _argUsers[1];

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
            title: Text(_visitedUserProfile.username),
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
                      _buildButtons(),
                      SizedBox(height: 10.0),
                      _buildStatContainer(),
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
