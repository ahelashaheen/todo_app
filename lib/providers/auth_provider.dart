import 'package:flutter/material.dart';
import 'package:to_do_app/model/myuser.dart';

class AuthProvider extends ChangeNotifier {
  MyUser? currentUser;

  void UpdateUser(MyUser newUser) {
    currentUser = newUser;
    notifyListeners();
  }
}