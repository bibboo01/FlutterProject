import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_t_ping/controllers/authController.dart';
import 'package:project_t_ping/models/std_model.dart';
import 'package:project_t_ping/varibles.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:provider/provider.dart';

class StdInfo {
  Future<void> add_info(
      BuildContext context,
      String stdId,
      int prefix,
      String stdFname,
      String stdLname,
      String stdNickname,
      int stdReligion,
      int major,
      String stdTel,
      String schName,
      int schProvince,
      String stdFatherName,
      String stdFatherTel,
      String stdMotherName,
      String stdMotherTel,
      String stdParentName,
      String stdParentTel,
      String stdParentRela,
      String allergicThings,
      String allergicDrugs,
      String allergicCondition,
      String accessToken,
      String refreshToken) async {
    final response = await http.post(
      Uri.parse("$apiURL/auth/fill_info"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "std_id": stdId,
        "prefix": prefix,
        "std_Fname": stdFname,
        "std_Lname": stdLname,
        "std_nickname": stdNickname,
        "std_religion": stdReligion,
        "major": major,
        "std_tel": stdTel,
        "sch_name": schName,
        "sch_province": schProvince,
        "std_father_name": stdFatherName,
        "std_father_tel": stdFatherTel,
        "std_mother_name": stdMotherName,
        "std_mother_tel": stdMotherTel,
        "std_parent_name": stdParentName,
        "std_parent_tel": stdParentTel,
        "std_parent_rela": stdParentRela,
        "allergic_things": allergicThings,
        "allergic_drugs": allergicDrugs,
        "allergic_condition": allergicCondition
      }),
    );
    print('post is  ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Product Post successfully');
    }
  }

  Future<List<studentInfo>> fetchStd(
      BuildContext context, String accessToken, String refreshToken) async {
    final response = await http.get(
      Uri.parse('$apiURL/auth/read_info'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    print("fetchall student is ${response.statusCode}");

    if (response.statusCode == 200) {
      print('Product fetched successfully');
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => studentInfo.fromJson(data)).toList();
    } else if (response.statusCode == 401) {
      print('logging out.');
      Logout(context);
      throw Exception('Token denied');
    } else if (response.statusCode == 403) {
      final newAccessToken =
          await AuthService().refreshToken(context, refreshToken);
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        return await fetchStd(context, accessToken, refreshToken);
      } else {
        print('logging out.');
        Logout(context);
      }
    }
    throw Exception('Failed to fetch student data: ${response.statusCode}');
  }

  Future<studentInfo> fetchstudent(BuildContext context, String id,
      String accessToken, String refreshToken) async {
    final response = await http.get(
      Uri.parse('$apiURL/auth/read_info/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    print("fetch student is ${response.statusCode}");

    if (response.statusCode == 200) {
      print('Product fetched successfully');
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return studentInfo.fromJson(jsonResponse);
    } else if (response.statusCode == 401) {
      print('logging out.');
      Logout(context);
      throw Exception('Token denied');
    } else if (response.statusCode == 403) {
      final newAccessToken =
          await AuthService().refreshToken(context, refreshToken);
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        return await fetchstudent(context, id, accessToken, refreshToken);
      } else {
        print('logging out.');
        Logout(context);
      }
    }
    throw Exception('Failed to fetch student data: ${response.statusCode}');
  }

  Future<void> delstd(BuildContext context, String id, String accessToken,
      String refreshToken) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiURL/auth/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      print("Delete response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        print('Delete successfully');
      } else if (response.statusCode == 401) {
        print('logging out.');
        Logout(context);
        throw Exception('Token denied');
      } else if (response.statusCode == 403) {
        final newAccessToken =
            await AuthService().refreshToken(context, refreshToken);
        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          return await delstd(context, id, accessToken, refreshToken);
        } else {
          print('logging out.');
          Logout(context);
        }
      }
    } catch (e) {
      print('Exception occurred while Delete student: $e');
    }
  }

  Future<void> editstudents(
      BuildContext context,
      String stdId,
      int prefix,
      String stdFname,
      String stdLname,
      String stdNickname,
      int stdReligion,
      int major,
      String stdTel,
      String schName,
      int schProvince,
      String stdFatherName,
      String stdFatherTel,
      String stdMotherName,
      String stdMotherTel,
      String stdParentName,
      String stdParentTel,
      String stdParentRela,
      String allergicThings,
      String allergicDrugs,
      String allergicCondition,
      String accessToken,
      String refreshToken) async {
    try {
      final response = await http.put(
        Uri.parse("$apiURL/auth/fill_info/$stdId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          "std_id": stdId,
          "prefix": prefix,
          "std_Fname": stdFname,
          "std_Lname": stdLname,
          "std_nickname": stdNickname,
          "std_religion": stdReligion,
          "major": major,
          "std_tel": stdTel,
          "sch_name": schName,
          "sch_province": schProvince,
          "std_father_name": stdFatherName,
          "std_father_tel": stdFatherTel,
          "std_mother_name": stdMotherName,
          "std_mother_tel": stdMotherTel,
          "std_parent_name": stdParentName,
          "std_parent_tel": stdParentTel,
          "std_parent_rela": stdParentRela,
          "allergic_things": allergicThings,
          "allergic_drugs": allergicDrugs,
          "allergic_condition": allergicCondition,
        }),
      );

      print("Edit response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        print('Student edited successfully');
      } else if (response.statusCode == 401) {
        print('logging out.');
        Logout(context);
        throw Exception('Token denied');
      } else if (response.statusCode == 403) {
        final newAccessToken =
            await AuthService().refreshToken(context, refreshToken);
        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          return await editstudents(
              context,
              stdId,
              prefix,
              stdFname,
              stdLname,
              stdNickname,
              stdReligion,
              major,
              stdTel,
              schName,
              schProvince,
              stdFatherName,
              stdFatherTel,
              stdMotherName,
              stdMotherTel,
              stdParentName,
              stdParentTel,
              stdParentRela,
              allergicThings,
              allergicDrugs,
              allergicCondition,
              accessToken,
              refreshToken);
        } else {
          print('logging out.');
          Logout(context);
        }
      }
    } catch (e) {
      print('Exception occurred while editing student: $e');
    }
  }

  void Logout(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.onLogout();
    Navigator.pushNamed(context, '/');
  }
}
