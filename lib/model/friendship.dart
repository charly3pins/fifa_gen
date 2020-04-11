import 'package:flutter/foundation.dart';

/*
const (
	StatusCodePending  = 0
	StatusCodeAccepted = 1
	StatusCodeDecline  = 2
	StatusCodeBlocked  = 3
)
 */
class Friendship {
  String userOneID;
  String userTwoID;
  int status;
  String actionUserID;

  Friendship({this.userOneID, this.userTwoID, this.status, this.actionUserID});

  factory Friendship.fromJSON(Map<String, dynamic> parsedJson) {
    if(parsedJson.length == 0) {
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
