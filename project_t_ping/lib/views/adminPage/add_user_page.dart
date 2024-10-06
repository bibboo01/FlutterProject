import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_t_ping/controllers/authController.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  void register() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;

    try {
      await AuthService().register(username, password, email);
      _showSuccessDialog(context, 'Add user successful');
      Navigator.pushReplacementNamed(context, '/admin');
    } catch (e) {
      _showErrorDialog('Add user Failed ');
      print(e);
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Successful',
        text: message, // Custom message
        confirmBtnText: 'OK',
        onConfirmBtnTap: () {
          Navigator.pop(context); // Close the dialog
        },
        autoCloseDuration: Duration(seconds: 2));
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
      appBar: AppBar(
        title: Text('Add User'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        // Wrap the body in a SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create a New User',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _usernameController,
                    label: 'Username',
                    inputType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
                    ],
                    maxLength: 20,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                        return 'Username can only contain letters';
                      }
                      return null; // Valid input
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller:
                        _passwordController, // Assuming you have a password controller
                    label: 'Password',
                    inputType: TextInputType.visiblePassword,
                    obscureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9]')) // Letters and numbers only
                    ],
                    maxLength: 20,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])')
                          .hasMatch(value)) {
                        return 'Password must contain both letters and numbers';
                      }
                      return null; // Valid input
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    inputType: TextInputType.emailAddress,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9._%+-@]'))
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@tsu\.ac\.th$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address ending with @tsu.ac.th';
                      }
                      return null; // Valid input
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.blueAccent,
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          register();
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType inputType,
    bool obscureText = false,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      keyboardType: inputType,
      obscureText: obscureText,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }
}
