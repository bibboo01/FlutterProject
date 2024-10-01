import 'package:flutter/material.dart';
import 'package:project_t_ping/controllers/userController.dart';
import 'package:project_t_ping/models/user_model.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:provider/provider.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  int? _valueRole; // get value or fetch value
  int? _selectRole; // save value in database
  final Map<int, String> _roles = {0: 'Waiting', 1: 'Admin', 2: 'User'};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ModalRoute.of(context)!.settings.arguments
        as userModel; // Ensure proper case
    _fetchUser(user.id);
  }

  void _fetchUser(String id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;
    if (id.isNotEmpty) {
      final data = await Usercontroller().getUser(
          context, id, accessToken, refreshToken); // Ensure proper case
      _usernameController.text = data.username;
      _emailController.text = data.email;
      _valueRole = data.role; // Assuming data.role is an int
    }
  }

  Future<void> _updateUser(String id) async {
    final username = _usernameController.text;
    final email = _emailController.text;

    final role = _roles[_selectRole];

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;
    print(
        'Updating user: $id, Username: $username, Email: $email, Role: $role');
    try {
      await Usercontroller().updateUser(
          context,
          id,
          username,
          email,
          _selectRole!,
          accessToken,
          refreshToken); // Updated to exclude password
      Navigator.pushNamed(context, '/admin');
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _valueRole,
              hint: const Text('Select Role'),
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
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final getUser = ModalRoute.of(context)!.settings.arguments
                    as userModel; // Ensure proper case
                _updateUser(getUser.id);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
