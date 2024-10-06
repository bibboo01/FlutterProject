import 'package:flutter/material.dart';
import 'package:project_t_ping/controllers/authController.dart';
import 'package:project_t_ping/models/user_model.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

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
        final String? name = userModel.user.username;

        final userProvider = Provider.of<UserProvider>(context, listen: false);

        userProvider.saveUser(userModel.user, userModel.token);
        userProvider.setCurrentUserId(userModel.user.id);

        _showLoginSuccessDialog(role!, name!);
        _usernameController.clear();
        _passwordController.clear();
      } catch (e) {
        print(e);
        _showErrorDialog('Login Failed');
      }
    }
  }

  Future<void> checkRole(int role) async {
    if (role == 1) {
      Navigator.pushReplacementNamed(context, '/admin');
    } else if (role == 2) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void showConfirmationAlert(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      text: 'Waiting for confirmation from the system',
      autoCloseDuration:
          Duration(seconds: 5), // Automatically close after 2 seconds
    );
  }

  void _showLoginSuccessDialog(int role, String name) {
    checkRole(role);
    if (role == 1 || role == 2) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Login Successful',
        text: 'Welcome $name to the page!',
        autoCloseDuration: const Duration(seconds: 3),
        showConfirmBtn: true,
      );
    } else if (role == 0) {
      showConfirmationAlert(context);
    }
  }

  void _showErrorDialog(String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Warning',
      text: message,
      autoCloseDuration: const Duration(seconds: 3),
      showConfirmBtn: true,
      confirmBtnText: 'OK',
      confirmBtnColor: Colors.redAccent,
      onConfirmBtnTap: () {
        Navigator.of(context).pop(); // Optional: Close the dialog
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(
                                  8), // Padding around the button
                              shape:
                                  CircleBorder(), // Circular shape for the button
                              backgroundColor: Colors.blueAccent
                                  .withOpacity(0.2), // Light red background
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context,
                                  '/'); // Navigate back to the index page
                            },
                            child: Icon(
                              Icons.clear,
                              color: Colors.blue, // Icon color
                              size: 24, // Icon size
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/Image/Logo/SciLogo.png',
                        height: 50,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.grey[200],
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
                          prefixIcon: Icon(Icons.lock),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _login,
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/Register');
                        },
                        child: Text('Don\'t have an account? Register'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
