class Friendship {
  String userOneID;
  String userTwoID;
  int status;
  String actionUserID;

  Friendship({this.userOneID, this.userTwoID, this.status, this.actionUserID});

  factory Friendship.fromJson(Map<String, dynamic> parsedJson) {
    return Friendship(
      userOneID: parsedJson['userOneID'],
      userTwoID: parsedJson['userTwoID'],
      status: parsedJson['status'],
      actionUserID: parsedJson['actionUserID'],
    );
  }

  Map<String, dynamic> toJson() => {
        "userOneID": userOneID,
        "userTwoID": userTwoID,
        "status": status,
        "actionUserID": actionUserID,
      };
}
