import 'package:flutter/material.dart';
import 'package:project_t_ping/views/adminPage/add_user_page.dart';
import 'package:project_t_ping/views/admin_page.dart';
import 'package:project_t_ping/views/adminPage/editPage.dart';
import 'package:project_t_ping/views/form_page.dart';
import 'package:project_t_ping/views/index.dart';
import 'package:project_t_ping/views/login_page.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:project_t_ping/views/register_page.dart';
import 'package:project_t_ping/views/userpage/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => UserProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Authentication',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => IndexPage(),
        '/Student': (context) => const StdForm(),
        '/login': (context) => LoginPage(),
        '/Register': (context) => const register_page(),
        '/admin': (context) => AdminPage(),
        '/editPage': (context) => const EditPage(),
        '/home': (context) => HomePage(), //after pass login
        '/adduserPage': (context) => const AddUserPage(),
      },
    );
  }
}
