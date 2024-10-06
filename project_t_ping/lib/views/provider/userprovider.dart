import 'package:flutter/material.dart';
import 'package:project_t_ping/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  String? _user;
  String? _email;
  int? _role;
  String? _accessToken;
  String? _refreshToken;

  String? get user => _user;
  String? get email => _email;
  int? get role => _role;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  void saveUser(userModel user, Token token) {
    _user = user.username;
    _email = user.email;
    _role = user.role;
    _accessToken = token.accessToken;
    _refreshToken = token.refreshToken;
    notifyListeners();
  }

  void onLogout() {
    _user = null;
    _email = null;
    _role = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  void updateAccessToken(String token) {
    _accessToken = token;
    notifyListeners();
  }
}
