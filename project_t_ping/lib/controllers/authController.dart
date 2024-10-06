import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_t_ping/models/user_model.dart';
import 'package:project_t_ping/varibles.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:provider/provider.dart';

class AuthService {
  Future<User> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$apiURL/auth/login"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Failed to login';
        throw Exception('Failed to login: $errorMessage');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<void> register(String username, String password, String email) async {
    final response = await http.post(
      Uri.parse("$apiURL/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "email": email,
        "role": 0
      }),
    );
    print(response.statusCode);
  }

  Future<String?> refreshToken(
      BuildContext context, String refreshtoken) async {
    final response = await http.post(Uri.parse('$apiURL/auth/refresh'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": refreshtoken}));
    print(response.statusCode);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String newAccessToken = data['accessToken'];
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateAccessToken(newAccessToken);
      return newAccessToken;
    } else {
      print(
          'Error refreshing token: ${response.statusCode} - ${response.body}');
      return null;
    }
  }
}
