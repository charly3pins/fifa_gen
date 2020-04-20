import 'package:fifagen/core/constants/app_constants.dart';
import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/viewmodels/views/group_list_view_model.dart';
import 'package:fifagen/ui/widgets/base_widget.dart';
import 'package:fifagen/ui/widgets/group_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("group_list_view => Build");
    return BaseWidget<GroupListViewModel>(
      model: GroupListViewModel(
        api: Provider.of(context),
      ),
      onModelReady: (model) =>
          model.findGroups(Provider.of<User>(context, listen: false).id),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.transparent,
        body: model.groups == null || model.groups.isEmpty
            ? Center(
                child: Text("Create your first group"),
              )
            : ListView.builder(
                itemCount: model.groups.length,
                itemBuilder: (context, index) => GroupListItem(
                  group: model.groups[index],
                  onTap: () {
                    // TODO go to group details
                  },
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, RoutePaths.GroupCreate);
          },
          child: Icon(Icons.add, color: Colors.black),
          backgroundColor: Colors.amberAccent,
        ),
      ),
    );
  }
}
