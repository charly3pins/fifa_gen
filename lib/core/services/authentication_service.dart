import 'dart:async';

import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/services/api.dart';

class AuthenticationService {
  final Api _api;

  AuthenticationService({Api api}) : _api = api;

  StreamController<User> _userController = StreamController<User>();

  Stream<User> get user => _userController.stream;

  Future<bool> logIn(User user) async {
    print("AuthenticationService => logIn");
    return await _api.logIn(user).then((fetchedUser) {
      var hasUser = fetchedUser != null;
      if (hasUser) {
        _userController.add(fetchedUser);
      }
      print("AuthenticationService => OK");
      return hasUser;
    }).catchError((e) {
      print("AuthenticationService => ERROR: $e");
      throw (e);
    });
  }

  void logOut(User user) {
    // TODO check if its necessary to clean something from the Stream
  }
}
