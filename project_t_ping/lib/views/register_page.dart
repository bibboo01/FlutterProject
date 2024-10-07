import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_t_ping/controllers/authController.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

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

  void _showSuccessDialog(BuildContext context, String message) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Successful',
        text: message,
        confirmBtnText: 'OK',
        onConfirmBtnTap: () {
          Navigator.pop(context);
        },
        autoCloseDuration: Duration(seconds: 2));
  }

  void register() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;

    try {
      await AuthService().register(username, password, email);
      _showSuccessDialog(context, 'Register successful');
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print(e);
      _showErrorDialog('Error: $e');
    }
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
                    children: [
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
                      Text(
                        'Create an Account',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'ชื่อผู้ใช้',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        maxLength: 20,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z]')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกชื่อผู้ใช้';
                          }
                          if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                            return 'ชื่อผู้ใช้ต้องมีตัวอักษรเท่านั้น';
                          }
                          if (value.length <= 10) {
                            return 'ต้องมีตัวอักษร 10 ตัวขึ้นไป';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'รหัสผ่าน',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        obscureText: true,
                        maxLength: 20,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9]')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกรหัสผ่าน';
                          }
                          if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])')
                              .hasMatch(value)) {
                            return 'รหัสผ่านจะต้องมีทั้งตัวอักษรและตัวเลข';
                          }
                          if (value.length <= 12) {
                            return 'ต้องมีตัวอักษร 12 ตัวขึ้นไป';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'อีเมล',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกอีเมล์';
                            }
                            if (!RegExp(r'^[a-zA-Z0-9._%+-]+@tsu\.ac\.th$')
                                .hasMatch(value)) {
                              return 'กรุณากรอกที่อยู่อีเมลที่ถูกต้องซึ่งลงท้ายด้วย @tsu.ac.th';
                            }
                            return null;
                          }),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            register();
                          } else {
                            _showErrorDialog('Registration failed');
                          }
                        },
                        child: Text('Register'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text('Already have an account? Login'),
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
