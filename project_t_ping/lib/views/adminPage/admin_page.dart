import 'package:flutter/material.dart';
import 'package:project_t_ping/controllers/userController.dart';
import 'package:project_t_ping/models/user_model.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<userModel> _user = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAlluser(); // Fetch users when the widget is initialized
    _refreshData();
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // Update your state if needed
    });
  }

  void _fetchAlluser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;
    try {
      final allUser = await Usercontroller()
          .fetchUser(context, accessToken!, refreshToken!);
      setState(() {
        _user = allUser;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Set loading to false
        _errorMessage = e.toString(); // Store the error message
      });
    }
  }

  void _deluser(String id, String username) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;
    // Show confirmation dialog before deleting
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this $username?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false on cancel
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true on delete
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await Usercontroller()
            .delUser(context, id, accessToken!, refreshToken!);
        _fetchAlluser();
      } catch (e) {
        print(e);
      }
    }
  }

  String setrole(int? num) {
    if (num == 0) {
      return 'Waiting';
    } else if (num == 1) {
      return 'Admin';
    } else if (num == 2) {
      return 'User';
    } else {
      return 'Unknown Role'; // Fallback for unexpected values
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/adduserPage');
            },
          ),
          IconButton(
            icon: Icon(Icons.post_add), // Use any appropriate icon
            onPressed: () {
              Navigator.pushNamed(context, '/Student');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('This is Student List'),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator()) // Loading indicator
                  : _errorMessage != null
                      ? Center(
                          child: Text('Error: $_errorMessage')) // Error message
                      : ListView.builder(
                          itemCount: _user.length,
                          itemBuilder: (context, index) {
                            final fetchuser = _user[index];
                            return ListTile(
                              title: Text(
                                  fetchuser.username), // Handle null username
                              subtitle: Text(
                                "Role: ${setrole(fetchuser.role)}", // Handle null role
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/editPage',
                                        arguments:
                                            fetchuser, // Pass the user model if needed
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _deluser(
                                          fetchuser.id, fetchuser.username);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
