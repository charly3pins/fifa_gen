import 'package:fifagen/core/constants/app_constants.dart';
import 'package:fifagen/core/models/user.dart';
import 'package:fifagen/core/services/api.dart';
import 'package:fifagen/core/services/authentication_service.dart';
import 'package:fifagen/core/services/notifications_service.dart';
import 'package:fifagen/core/viewmodels/views/notification_list_view_model.dart';
import 'package:fifagen/ui/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: Api()),
        ProxyProvider<Api, AuthenticationService>(
          update: (context, api, authenticationService) =>
              AuthenticationService(api: api),
        ),
        ProxyProvider<Api, NotificationsService>(
          update: (context, api, authenticationService) =>
              NotificationsService(api: api),
        ),
        StreamProvider<User>(
          create: (context) =>
              Provider.of<AuthenticationService>(context, listen: false).user,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FIFA Tournaments Generator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: RoutePaths.Login,
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
