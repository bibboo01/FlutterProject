import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_t_ping/controllers/authController.dart';
import 'package:project_t_ping/models/user_model.dart';
import 'package:project_t_ping/varibles.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:provider/provider.dart';

class Usercontroller {
  Future<List<userModel>> fetchUser(
      BuildContext context, String accessToken, String refreshToken) async {
    final response = await http.get(
      Uri.parse('$apiURL/auth/read/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((alluser) => userModel.fromJson(alluser))
          .toList();
    } else if (response.statusCode == 401) {
      print('logging out.');
      Logout(context);
      throw Exception('Token denied');
    } else if (response.statusCode == 403) {
      final newAccessToken =
          await AuthService().refreshToken(context, refreshToken);
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        return await fetchUser(context, accessToken, refreshToken);
      } else {
        print('logging out.');
        Logout(context);
      }
    }
    throw Exception('Failed to fetch user data: ${response.statusCode}');
  }

  Future<userModel> getUser(BuildContext context, String id, String accessToken,
      String refreshToken) async {
    final response = await http.get(
      Uri.parse('$apiURL/auth/read/user/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      print('Fetch User successfully');
      return userModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      print('logging out.');
      Logout(context);
      throw Exception('Token denied');
    } else if (response.statusCode == 403) {
      final newAccessToken =
          await AuthService().refreshToken(context, refreshToken);
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        return await getUser(context, id, newAccessToken, refreshToken);
      } else {
        print('logging out.');
        Logout(context);
      }
    }
    throw Exception('Failed to fetch user data: ${response.statusCode}');
  }

  Future<void> updateUser(BuildContext context, String id, String username,
      String email, int role, String accessToken, String refreshToken) async {
    final response = await http.put(
      Uri.parse('$apiURL/auth/edit/user/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "username": username,
        "email": email,
        "role": role,
      }),
    );
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('User updated successfully');
    } else if (response.statusCode == 401) {
      print('logging out.');
      Logout(context);
      throw Exception('Token denied');
    } else if (response.statusCode == 403) {
      final newAccessToken =
          await AuthService().refreshToken(context, refreshToken);
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        return await updateUser(
            context, id, username, email, role, accessToken, refreshToken);
      } else {
        print('logging out.');
        Logout(context);
      }
    }
  }

  Future<void> delUser(BuildContext context, String id, String accessToken,
      String refreshToken) async {
    final response = await http.delete(
      Uri.parse('$apiURL/auth/del/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('User Delete successfully');
    } else if (response.statusCode == 401) {
      print('logging out.');
      Logout(context);
      throw Exception('Token denied');
    } else if (response.statusCode == 403) {
      final newAccessToken =
          await AuthService().refreshToken(context, refreshToken);
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        return await delUser(context, id, newAccessToken, refreshToken);
      } else {
        print('logging out.');
        Logout(context);
      }
    }
  }

  void Logout(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.onLogout();
    Navigator.pushNamed(context, '/');
  }
}
