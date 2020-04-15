class Friendship {
  String userOneID;
  String userTwoID;
  int status;
  String actionUserID;

  Friendship({this.userOneID, this.userTwoID, this.status, this.actionUserID});

  factory Friendship.fromJSON(Map<String, dynamic> parsedJson) {
    if (parsedJson.length == 0) {
      return null;
    }
    return Friendship(
      userOneID: parsedJson['userOneID'],
      userTwoID: parsedJson['userTwoID'],
      status: parsedJson['status'],
      actionUserID: parsedJson['actionUserID'],
    );
  }

  Map<String, dynamic> toJSON() => {
        "userOneID": userOneID,
        "userTwoID": userTwoID,
        "status": status,
        "actionUserID": actionUserID,
      };
}

class FriendshipStatus {
  static const int Pending = 0;
  static const int Accepted = 1;
  static const int Declined = 2;
  static const int Blocked = 3;
}