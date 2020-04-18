import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/services/authentication_service.dart';
import 'package:fifagen/core/viewmodels/base_model.dart';
import 'package:flutter/widgets.dart';

class LoginViewModel extends BaseModel {
  AuthenticationService _authenticationService;

  LoginViewModel({
    @required AuthenticationService authenticationService,
  }) : _authenticationService = authenticationService;

  Future<bool> logIn(User user) async {
    print("loginviewmodel => logIn");
    setBusy(true);
    return await _authenticationService.logIn(user).then((success) {
      print("loginviewmodel => OK");
      setBusy(false);
      setError("");
      return success;
    }).catchError((e) {
      print("loginviewmodel => ERROR: $e");
      setBusy(false);
      setError(e);
      return false;
    });
  }
}
