import 'package:fifagen/notifiers/auth_api.dart';
import 'package:fifagen/notifiers/users_api.dart';
import 'package:fifagen/widgets/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(FifaGenApp());

class FifaGenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthNotifier(),
          ),
          ChangeNotifierProvider(
            create: (context) => UsersNotifier(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AuthWidget(),
        ));
  }
}
