import 'package:fifagen/notifiers/auth_api.dart';
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
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AuthWidget(),
        ));
  }
}
