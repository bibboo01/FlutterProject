import 'package:flutter/material.dart';
import 'package:project_t_ping/controllers/userController.dart';
import 'package:project_t_ping/models/user_model.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
    _fetchAlluser();
  }

  void _showErrorDialog(String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'คำเตือน',
      text: message,
      autoCloseDuration: const Duration(seconds: 3),
      showConfirmBtn: true,
      confirmBtnText: 'โอเค',
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
        title: 'ประสบความสำเร็จ',
        text: message, // Custom message
        confirmBtnText: 'โอเค',
        onConfirmBtnTap: () {
          Navigator.pop(context); // Close the dialog
        },
        autoCloseDuration: Duration(seconds: 2));
  }

  void _fetchAlluser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;
    try {
      final allUser = await Usercontroller()
          .fetchUser(context, accessToken!, refreshToken!);

      setState(() {
        _user = allUser
            .where((user) => user.id != userProvider.currentUserId)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _deluser(String id, String username) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;

    // Show confirmation dialog using QuickAlert
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'ยืนยันการลบ',
      text: 'คุณแน่ใจหรือไม่ว่าต้องการลบ $username?',
      confirmBtnText: 'ลบ',
      cancelBtnText: 'ยกเลิก',
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () async {
        Navigator.of(context).pop(); // Close the alert
        try {
          await Usercontroller()
              .delUser(context, id, accessToken!, refreshToken!);
          _fetchAlluser();
          _showSuccessDialog(context, 'ลบเรียบร้อยแล้ว!');
        } catch (e) {
          print(e);
          _showErrorDialog('ไม่สามารถลบผู้ใช้: $e');
        }
      },
      onCancelBtnTap: () {
        Navigator.of(context).pop(); // Close the alert
      },
    );
  }

  String setrole(int? num) {
    switch (num) {
      case 0:
        return 'Waiting';
      case 1:
        return 'Admin';
      case 2:
        return 'User';
      default:
        return 'Unknown Role';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แดชบอร์ดผู้ดูแลระบบ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/adduserPage');
            },
          ),
          Builder(builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
        ],
      ),
      drawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              'รายชื่อผู้ใช้',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text('Error: $_errorMessage'))
                      : ListView.builder(
                          itemCount: _user.length,
                          itemBuilder: (context, index) {
                            final fetchuser = _user[index];
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(
                                  fetchuser.username,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "สถานะ: ${setrole(fetchuser.role)}",
                                  style: TextStyle(color: Colors.grey[600]),
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
                                          arguments: fetchuser,
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
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.onLogout();
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'ออกจากระบบสำเร็จ',
      text: 'คุณออกจากระบบเรียบร้อยแล้ว',
      confirmBtnText: 'โอเคร',
      confirmBtnColor: Colors.blue,
      onConfirmBtnTap: () {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      },
    );
  }

  Widget _buildDrawer() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? name = userProvider.user;
    String? email = userProvider.email;
    int? role = userProvider.role;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'อีเมล: $email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'สถานะ: ${setrole(role)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('แบบฟอร์มนิสิต'),
            onTap: () {
              Navigator.pushNamed(context, '/Student');
            },
          ),
          ListTile(
            leading: Icon(Icons.library_books),
            title: Text('รายงาน'),
            onTap: () {
              Navigator.pushNamed(context, '/reqadmin');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('ออกจากระบบ'),
            onTap: () {
              _logout(context);
            },
          ),
          Divider(), // Optional divider for better separation
          ListTile(
            title: Text(
              'ติดต่อเรา',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'คณะวิทยาศาสตร์และนวัตกรรมดิจิทัล\nมหาวิทยาลัยทักษิณ\n222 หมู่ 2 ต.บ้านพร้าว อ.ป่าพะยอม\nจ.พัทลุง 93210',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
