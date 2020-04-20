import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  bool _busy = false;
  String _error;

  bool get busy => _busy;
  String get error => _error;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  void setError(String value) {
    _error = value;
    notifyListeners();
  }
}
