import 'package:flutter/material.dart';
import 'package:project_t_ping/controllers/authController.dart';
import 'package:project_t_ping/models/user_model.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      try {
        final User? userModel = await AuthService().login(username, password);
        final int? role = userModel!.user.role;
        final String? name = userModel!.user.username;

        Provider.of<UserProvider>(context, listen: false)
            .saveUser(userModel.user, userModel.token);

        _showLoginSuccessDialog(role!, name!);
        _usernameController.clear();
        _passwordController.clear();
      } catch (e) {
        print(e);
        _showErrorDialog('Fail to Login');
      }
    }
  }

  Future<void> checkRole(int role) async {
    if (role == 1) {
      Navigator.pushReplacementNamed(context, '/admin');
    } else if (role == 2) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (role == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Waiting for confirmation from the system')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected user role')),
      );
    }
    if (role == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful')),
      );
    }
  }

  void _showLoginSuccessDialog(int _Role, String name) {
    checkRole(_Role!);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Successful'),
          content: Text('Welcome $name to Page'),
          actions: <Widget>[
            TextButton(
              child: Center(child: Text('OK')),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Warning')),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Center(child: Text('OK')),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(onPressed: _login, child: Text('Login')),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/Register');
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
