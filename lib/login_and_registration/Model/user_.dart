import 'package:flutter/material.dart';

class UserCredentials extends ChangeNotifier {
  String? busId;
  String? password;

  void setBusId(String busId) {
    this.busId = busId;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }
}
