import 'package:flutter/material.dart';
import 'package:project_t_ping/views/chart/first_chart.dart';
import 'package:project_t_ping/views/chart/list.dart';
import 'package:project_t_ping/views/chart/second.dart';

class HomePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<HomePage> {
  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // Update your state if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                const ChartTooltip(),
                const DonutChart(),
                ListCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
