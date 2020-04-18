import 'package:fifagen/notifiers/auth_api.dart';
import 'package:fifagen/widgets/auth.dart';
import 'package:fifagen/widgets/auth_builder.dart';
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
      child: AuthWidgetBuilder(
        builder: (context, user) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.indigo),
            home: AuthWidget(user: user),
          );
        },
      ),
    );
  }
}
