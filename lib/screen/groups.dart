import 'package:fifagen/model/user.dart';
import 'package:flutter/material.dart';

enum ViewMode { CREATE, EDIT, READ }

class GroupsScreen extends StatefulWidget {
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<GroupsScreen> {
  // Set initial mode to READ
  ViewMode _viewMode = ViewMode.READ;

  User _loggedUser;

  final _groupsFormKey = GlobalKey<FormState>();

  List<String> _users = <String>[
    '',
    'Carles',
    'Gerard',
    'Matheus',
    'Hector',
    'Abderra'
  ];
  String _user = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _loggedUser = ModalRoute.of(context).settings.arguments;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_viewMode) {
      case ViewMode.CREATE:
        return create(context);
      case ViewMode.EDIT:
        return edit(context);
      case ViewMode.READ:
        return read(context);
    }
  }

  Widget create(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _groupsFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Create Group",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "Name", hasFloatingPlaceholder: true),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the Group Name.';
                          }
                          return null;
                        },
                        //onSaved: (val) => setState(() => _user.name = val.trim()),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FormField(
                        builder: (FormFieldState state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              icon: const Icon(Icons.person_add),
                              labelText: 'User',
                            ),
                            isEmpty: _user == '',
                            child: new DropdownButtonHideUnderline(
                              child: new DropdownButton(
                                value: _user,
                                isDense: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    //newContact.favoriteColor = newValue;
                                    _user = newValue;
                                    state.didChange(newValue);
                                  });
                                },
                                items: _users.map((String value) {
                                  return new DropdownMenuItem(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Container(),
                          ),
                          FlatButton(
                            child: Text("Save"),
                            color: Color(0xFF4B9DFE),
                            textColor: Colors.white,
                            padding: EdgeInsets.only(
                                left: 38, right: 38, top: 15, bottom: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            onPressed: () {
                              final form = _groupsFormKey.currentState;
                              if (form.validate()) {
                                form.save();

                                /*FifaGenAPI().createUser(_user).then((usr) {
                          // Navigate to new page without back
                          // TODO Navigator.pushNamedReplacement(context,
                          Navigator.pushNamed(context, "/home",
                              arguments: usr);
                        }).catchError((e) {
                          // TODO improve this error check
                          showDialog(
                              context: context,
                              builder: (_) =>
                                  AlertDialog(title: Text(e)));
                        });*/
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ))));
  }

  Widget read(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                  leading: Icon(Icons.people), title: Text("Pollitas team")),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _viewMode = ViewMode.CREATE;
            });
          },
          child: Icon(Icons.add, color: Colors.black),
          backgroundColor: Colors.amberAccent,
        ));
  }

  Widget edit(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                  leading: Icon(Icons.people),
                  title: Text("EDIT Pollitas team")),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _viewMode = ViewMode.EDIT;
            });
          },
          child: Icon(Icons.add, color: Colors.black),
          backgroundColor: Colors.amberAccent,
        ));
  }
}
