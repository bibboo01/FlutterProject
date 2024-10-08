import 'package:flutter/material.dart';
import 'package:project_t_ping/views/chart/Chart.dart';
import 'package:project_t_ping/views/chart/first_chart.dart';
import 'package:project_t_ping/views/chart/list.dart';
import 'package:project_t_ping/views/chart/second.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Reqadmin extends StatefulWidget {
  const Reqadmin({super.key});

  @override
  State<Reqadmin> createState() => _ReqadminState();
}

class _ReqadminState extends State<Reqadmin> {
  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // Update your state if needed
    });
  }

  String setrole(int? num) {
    if (num == 0) {
      return 'Waiting';
    } else if (num == 1) {
      return 'Admin';
    } else if (num == 2) {
      return 'User';
    } else {
      return 'Unknown Role';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายงาน',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.navigate_before,
                color: Colors.white,
              )),
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                DonutChart(),
                MyChart(),
                ChartTooltip(),
                ListCard(),
              ],
            ),
          ),
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
      title: 'Logout Successful',
      text: 'You have been logged out successfully.',
      confirmBtnText: 'OK',
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
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Email: $email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Role: ${setrole(role)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              _logout(context);
            },
          ),
          Divider(), // Optional divider for better separation
          ListTile(
            title: Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'คณะวิทยาศาสตร์และนวัตกรรมดิจิทัล\n มหาวิทยาลัยทักษิณ\n222 หมู่ 2 ต.บ้านพร้าว อ.ป่าพะยอม\n จ.พัทลุง 93210',
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
