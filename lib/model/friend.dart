import 'package:flutter/foundation.dart';

class Friend {
  final String id;
  String sender;
  String receiver;
  String state;

  Friend({this.id, this.sender, this.receiver, this.state});

  factory Friend.fromJSON(Map<String, dynamic> parsedJson) {
    return Friend(
      id: parsedJson['id'],
      sender: parsedJson['sender'],
      receiver: parsedJson['receiver'],
      state: parsedJson['state'],
    );
  }

  Map<String, dynamic> toJSON() => {
        "id": id,
        "sender": sender,
        "receiver": receiver,
        "state": state,
      };
}
