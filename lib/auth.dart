import 'dart:async';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  bool _authenticated = false;

  bool get authenticated => _authenticated;

  // Simulating a login process
  Future<void> login(String email, String password) async {
    // Here you can implement your actual authentication logic,
    // for demonstration purpose, let's simulate a login process
    await Future.delayed(Duration(seconds: 2));
    
    // Assuming the login is successful, setting authenticated to true
    _authenticated = true;
    
    // Notifying listeners about the change
    notifyListeners();
  }

  // Simulating a logout process
  void logout() {
    // Here you can implement your actual logout logic
    _authenticated = false;
    
    // Notifying listeners about the change
    notifyListeners();
  }
}
