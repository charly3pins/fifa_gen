import 'package:fifagen/core/constants/app_constants.dart';
import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/viewmodels/views/login_view_model.dart';
import 'package:fifagen/ui/widgets/base_widget.dart';
import 'package:fifagen/ui/widgets/snack_bar_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _user = User();

  @override
  Widget build(BuildContext context) {
    return BaseWidget<LoginViewModel>(
      model: LoginViewModel(authenticationService: Provider.of(context)),
      //child: LoginHeader(controller: _controller),
      builder: (context, model, child) => Scaffold(
        //backgroundColor: backgroundColor,
        body: Scaffold(
            backgroundColor: Color.fromRGBO(36, 43, 47, 1),
            appBar: AppBar(
                title: Text(
              "Fifa Generator",
            )),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //child,
                model.busy
                    ? Center(
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: <Widget>[
                                CircularProgressIndicator(),
                              ],
                            )))
                    : _buildForm(context, model)
              ],
            )),
      ),
    );
  }

  Widget _buildForm(BuildContext context, LoginViewModel model) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 43.0),
        child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: _buildInputDecoration("Username"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Username.';
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: Color.fromRGBO(252, 252, 252, 1),
                        fontFamily: 'RadikalLight'),
                    onSaved: (val) =>
                        setState(() => _user.username = val.trim()),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: _buildInputDecoration("Password"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a Password.';
                      }
                      return null;
                    },
                    obscureText: true,
                    style: TextStyle(
                        color: Color.fromRGBO(252, 252, 252, 1),
                        fontFamily: 'RadikalLight'),
                    onSaved: (val) =>
                        setState(() => _user.password = val.trim()),
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    child: Text(
                      /*_authMode == AuthMode.LOGIN ? */ "Log in", // : "Sign up",
                      style: TextStyle(
                          color: Color.fromRGBO(40, 48, 52, 1),
                          fontFamily: 'RadikalMedium',
                          fontSize: 14),
                    ),
                    color: Colors.white,
                    elevation: 4.0,
                    onPressed: () async {
                      final form = _formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        form.reset();
                        var loginSuccess = await model.logIn(_user);
                        if (loginSuccess) {
                          _user = User();
                          Navigator.pushNamed(context, RoutePaths.Home);
                        }
                      }
                    },
                  ),
                  model.error != null && model.error.isNotEmpty
                      ? SnackBarLauncher(error: model.error)
                      : Container(),
                ],
              ),
            ),
          ),
        ));
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(252, 252, 252, 1))),
        hintText: hint,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(151, 151, 151, 1))),
        hintStyle: TextStyle(color: Color.fromRGBO(252, 252, 252, 1)),
        //icon: iconPath != '' ? Image.asset(iconPath) : null,
        errorStyle: TextStyle(color: Color.fromRGBO(248, 218, 87, 1)),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(248, 218, 87, 1))),
        focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(248, 218, 87, 1))));
  }
}
