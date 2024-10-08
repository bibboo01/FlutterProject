import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:project_t_ping/controllers/std_Controller.dart';
import 'package:project_t_ping/models/std_model.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:provider/provider.dart';

class ChartTooltip extends StatefulWidget {
  const ChartTooltip({super.key});

  @override
  State<ChartTooltip> createState() => _ChartTooltipState();
}

class _ChartTooltipState extends State<ChartTooltip> {
  List<studentInfo> _students = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _studentCount1 = 0;
  int _studentCount2 = 0;
  int _studentCount3 = 0;
  int _studentCount4 = 0;
  int _studentCount5 = 0;
  int _studentCount7 = 0;

  @override
  void initState() {
    super.initState();
    _fetchAllStudents();
  }

  void _fetchAllStudents() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;
    try {
      final allStudents =
          await StdInfo().fetchStd(context, accessToken!, refreshToken!);
      setState(() {
        _students = allStudents;
        _isLoading = false;
      });
      _calculateStudentCounts();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _calculateStudentCounts() {
    setState(() {
      _studentCount1 = _students
          .where((student) => student.stdInfo.stdId.startsWith('65'))
          .length;
      _studentCount2 = _students
          .where((student) => student.stdInfo.stdId.startsWith('66'))
          .length;
      _studentCount3 = _students
          .where((student) => student.stdInfo.stdId.startsWith('67'))
          .length;
      _studentCount4 = _students
          .where((student) => student.stdInfo.stdId.startsWith('68'))
          .length;
      _studentCount5 = _students
          .where((student) => student.stdInfo.stdId.startsWith('69'))
          .length;
      _studentCount7 = _students
          .where((student) => student.stdInfo.stdId.startsWith('70'))
          .length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage'));
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildBarChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'สรุปยอดนิสิต\nแต่ละปีการศึกษา',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    List<ChartData> chartData = [
      ChartData(year: '2565', count: _studentCount1),
      ChartData(year: '2566', count: _studentCount2),
      ChartData(year: '2567', count: _studentCount3),
      ChartData(year: '2568', count: _studentCount4),
      ChartData(year: '2569', count: _studentCount5),
      ChartData(year: '2570', count: _studentCount7),
    ];

    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
        series: <CartesianSeries<ChartData, String>>[
          ColumnSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.year,
            yValueMapper: (ChartData data, _) => data.count,
            borderRadius: BorderRadius.circular(10), // Set corner radius
            dataLabelSettings: DataLabelSettings(isVisible: true),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String year;
  final int count;

  ChartData({required this.year, required this.count});
}
