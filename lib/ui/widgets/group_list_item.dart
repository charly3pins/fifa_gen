import 'package:fifagen/core/models/group.dart';
import 'package:flutter/material.dart';

class GroupListItem extends StatelessWidget {
  final Group group;
  final Function onTap;
  const GroupListItem({this.group, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: ListTile(
          leading: Icon(Icons.group),
          title: Text(
            group.name,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Row(
            children: <Widget>[
              for (var member in group.members) Text("${member.username} "),
            ],
          ),
        ),
      ),
    );
  }
}
