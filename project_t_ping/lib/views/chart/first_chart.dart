import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
  late int showingTooltip;
  List<studentInfo> _students = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _studentCount2022 = 0;
  int _studentCount2023 = 0;
  int _studentCount2024 = 0;
  int _studentCount2025 = 0;
  int _studentCount2026 = 0;
  int _studentCount2027 = 0;

  @override
  void initState() {
    super.initState();
    showingTooltip = -1;
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
      _studentCount2022 = _students
          .where((student) => student.stdInfo.stdId.startsWith('65'))
          .length;
      _studentCount2023 = _students
          .where((student) => student.stdInfo.stdId.startsWith('66'))
          .length;
      _studentCount2024 = _students
          .where((student) => student.stdInfo.stdId.startsWith('67'))
          .length;
      _studentCount2025 = _students
          .where((student) => student.stdInfo.stdId.startsWith('68'))
          .length;
      _studentCount2026 = _students
          .where((student) => student.stdInfo.stdId.startsWith('69'))
          .length;
      _studentCount2027 = _students
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
          'Student Enrollment',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchCallback: (event, response) {
              if (response != null &&
                  response.spot != null &&
                  event is FlTapUpEvent) {
                setState(() {
                  final x = response.spot!.touchedBarGroup.x;
                  showingTooltip = showingTooltip == x ? -1 : x;
                });
              }
            },
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return Text('2022');
                    case 1:
                      return Text('2023');
                    case 2:
                      return Text('2024');
                    case 3:
                      return Text('2025');
                    case 4:
                      return Text('2026');
                    case 5:
                      return Text('2027');
                    default:
                      return Text('');
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            _buildBarGroup(0, _studentCount2022, Colors.blue),
            _buildBarGroup(1, _studentCount2023, Colors.green),
            _buildBarGroup(2, _studentCount2024, Colors.red),
            _buildBarGroup(3, _studentCount2025, Colors.orange),
            _buildBarGroup(4, _studentCount2026, Colors.yellow),
            _buildBarGroup(5, _studentCount2027, Colors.lime),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, int count, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: count.toDouble(),
          color: color,
          width: 20,
        ),
      ],
      showingTooltipIndicators: showingTooltip == x ? [0] : [],
    );
  }
}
