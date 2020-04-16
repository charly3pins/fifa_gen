import 'package:flutter/material.dart';

class SnackBarLauncher extends StatelessWidget {
  final String error;

  const SnackBarLauncher({Key key, @required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _displaySnackBar(context, error: error));
    }
    // Placeholder container widget
    return Container();
  }

  void _displaySnackBar(BuildContext context, {@required String error}) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red[600],
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.error),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 16), child: Text(error))),
        ],
      ),
    );
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
