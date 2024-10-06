import 'package:flutter/material.dart';
import 'package:project_t_ping/views/chart/Chart.dart';
import 'package:project_t_ping/views/chart/first_chart.dart';
import 'package:project_t_ping/views/chart/list.dart';
import 'package:project_t_ping/views/chart/second.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // Update your state if needed
    });
  }

  void _logout(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.onLogout();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  String _setRole(int? num) {
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
        title: Text('Home'),
        automaticallyImplyLeading: false,
        actions: [
          // Use a Builder to create a new context that has a Scaffold ancestor
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu),
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

  Widget _buildDrawer() {
    final userProvider = Provider.of<UserProvider>(context);
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
                  'Welcome $name',
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
                  'Role: ${_setRole(role)}',
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
          Divider(),
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
              'คณะวิทยาศาสตร์และนวัตกรรมดิจิทัล\nมหาวิทยาลัยทักษิณ\n222 หมู่ 2 ต.บ้านพร้าว อ.ป่าพะยอม\nจ.พัทลุง 93210',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
