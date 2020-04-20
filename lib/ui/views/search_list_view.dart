import 'package:fifagen/core/constants/app_constants.dart';
import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/viewmodels/views/search_list_view_model.dart';
import 'package:fifagen/ui/views/arguments/user_profile_view_arguments.dart';
import 'package:fifagen/ui/widgets/base_widget.dart';
import 'package:fifagen/ui/widgets/snack_bar_launcher.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SearchListView extends StatefulWidget {
  final User user;

  const SearchListView({this.user});

  @override
  State<StatefulWidget> createState() => _SearchState();
}

class _SearchState extends State<SearchListView> {
  final FocusNode myFocusNode = new FocusNode();

  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget<SearchListViewModel>(
      model: SearchListViewModel(
        api: Provider.of(context),
      ),
      onModelReady: (model) => _searchQuery.addListener(() {
        var query = _searchQuery.text;

        if (query.isEmpty) {
          model.clearUsers();
          return;
        }

        model.setError(null);
        model.findUsers(query).catchError((_) {
          model.setError(Errors.FindingUsers);
        });
      }),
      builder: (context, model, child) => Scaffold(
        key: key,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: TextField(
            autofocus: true,
            controller: _searchQuery,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search users...",
                hintStyle: TextStyle(color: Colors.white)),
          ),
        ),
        body: buildBody(context, _searchQuery.text, model),
      ),
    );
  }

  Widget buildBody(
      BuildContext context, String query, SearchListViewModel model) {
    // TODO clean logged username correctly
    for (var i = 0; i < model.results.length; i++) {
      if (model.results[i].id == widget.user.id) {
        model.results.removeAt(i);
        break;
      }
    }

    if (model.error != null) {
      return Container(
        child: SnackBarLauncher(error: model.error),
      );
    } else if (query.isNotEmpty && model.results.length == 0) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Text(
            Errors.NoResultsFoundFor + '"$query"',
            textAlign: TextAlign.center,
          ));
    } else {
      return model.busy
          ? CircularProgressIndicator()
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              itemCount: model.results.length,
              itemBuilder: (BuildContext context, int index) {
                var user = model.results[index];
                return GestureDetector(
                    onTap: () async {
                      await model
                          .getFriendship(
                              widget.user.id, model.results[index].id)
                          .then((friendship) {
                        Navigator.pushNamed(context, RoutePaths.UserProfile,
                            arguments: UserProfileViewArguments(
                                user: model.results[index],
                                friendship: friendship));
                      });
                    },
                    child: Card(
                        child: ListTile(
                      leading: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/profile/" + user.profilePicture),
                          ),
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                      title: Text(
                        user.username,
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(user.name),
                    )));
              });
    }
  }
}
