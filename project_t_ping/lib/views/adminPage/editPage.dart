import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_t_ping/controllers/userController.dart';
import 'package:project_t_ping/models/user_model.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  int? _valueRole; // Get value or fetch value
  int? _selectRole; // Save value in database
  final Map<int, String> _roles = {0: 'Waiting', 1: 'Admin', 2: 'User'};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ModalRoute.of(context)!.settings.arguments as userModel;
    _fetchUser(user.id);
  }

  void _fetchUser(String id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;
    if (id.isNotEmpty) {
      final data = await Usercontroller()
          .getUser(context, id, accessToken!, refreshToken!);
      _usernameController.text = data.username;

      _emailController.text = data.email;
      _valueRole = data.role;
    }
  }

  Future<void> _updateUser(String id) async {
    final username = _usernameController.text;
    final email = _emailController.text;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;

    try {
      await Usercontroller().updateUser(context, id, username, email,
          _selectRole!, accessToken!, refreshToken!);
      Navigator.pushNamed(context, '/admin');
      _showSuccessDialog(context, 'ผู้ใช้รายการได้รับการอัปเดตเรียบร้อยแล้ว');
    } catch (e) {
      print('เกิดข้อผิดพลาดในการอัปเดตผู้ใช้: $e');
      _showErrorDialog('ไม่สามารถอัปเดตผู้ใช้');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขผู้ใช้'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'แก้ไขรายละเอียดผู้ใช้',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _usernameController,
                label: 'ชื่อผู้ใช้',
                hint: 'กรอกชื่อผู้ใช้ของคุณ',
                inputType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
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
                  return null; // Valid input
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: 'อีเมล',
                hint: 'ใส่อีเมลของคุณ',
                inputType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9._%+-@]'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกอีเมล์';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@tsu\.ac\.th$')
                      .hasMatch(value)) {
                    return 'กรุณากรอกที่อยู่อีเมลที่ถูกต้องซึ่งลงท้ายด้วย @tsu.ac.th';
                  }
                  return null; // Valid input
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _valueRole,
                hint: const Text('เลือกสถานะ'),
                items: _roles.entries
                    .map((entry) => DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectRole = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final getUser =
                        ModalRoute.of(context)!.settings.arguments as userModel;
                    _updateUser(getUser.id);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: const Text('บันทึกการเปลี่ยนแปลง'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'สำเร็จ',
        text: message,
        confirmBtnText: 'โอเค',
        onConfirmBtnTap: () {
          Navigator.pop(context);
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
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextInputType inputType,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      keyboardType: inputType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }
}
