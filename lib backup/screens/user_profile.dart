import 'package:fifagen/models/user.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  // In the constructor, require a User.
  UserProfileScreen({Key key, @required this.user}) : super(key: key);

  final User user;

  Widget _buildProfileImage() {
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
        // Friendship friendship = Friendship(
        //     userOneID: _loggedUser.id,
        //     userTwoID: user.id,
        //     status: FriendshipStatus.Pending,
        //     actionUserID: _loggedUser.id);
        // FifaGenAPI().createFriendRequest(friendship).then((friendRequest) {
        //   setState(() {
        //     _requestState = RequestState.PENDING;
        //     _friendship = friendRequest;
        //   });
        // }).catchError((e) {
        //   // TODO improve this error check
        //   showDialog(
        //       context: context, builder: (_) => AlertDialog(title: Text(e)));
        // });
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
            // The pending requests will be from the user.id,
            // so the _loggedUser will be the userTwo always
            // Friendship friendship = Friendship(
            //     userOneID: user.id,
            //     userTwoID: _loggedUser.id,
            //     status: FriendshipStatus.Accepted,
            //     actionUserID: _loggedUser.id);
            // FifaGenAPI().answerFriendRequest(friendship).then((resp) {
            //   friendship.actionUserID = user.id;
            //   friendship.status = FriendshipStatus.Pending;
            //   widget.parentAction(friendship);
            //   setState(() {
            //     _requestState = RequestState.ACCEPTED;
            //   });
            // }).catchError((e) {
            //   // TODO improve this error check
            //   showDialog(
            //       context: context,
            //       builder: (_) => AlertDialog(title: Text(e.toString())));
            // });
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

  // Widget _buildStateButton() {
  //   switch (_requestState) {
  //     case RequestState.ACCEPTED:
  //       return _buildAccepted();
  //     case RequestState.PENDING:
  //       if (_friendship.actionUserID != _loggedUser.id) {
  //         return _buildAnswerRequestButtons();
  //       }
  //       return _buildRequested();
  //     // TODO add DECLINED and BLOCKED
  //     default:
  //       return _buildAddFriend();
  //   }
  // }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        //_buildStateButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(user.username),
      ),
      body: Column(
        children: <Widget>[
          _buildProfileImage(),
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