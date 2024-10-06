import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project_t_ping/controllers/std_Controller.dart';
import 'package:project_t_ping/models/std_model.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:provider/provider.dart';

class DonutChart extends StatefulWidget {
  const DonutChart({super.key});

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  List<studentInfo> _students = [];
  bool _isLoading = true;
  String? _errorMessage;

  final Map<int, String> _Majors = {
    0: "วท.บ.เคมี",
    1: "วท.บ.วิทยาศาสตร์สิ่งแวดล้อม",
    2: "วท.บ.คณิตศาสตร์และการจัดการข้อมูล",
    3: "วท.บ.วิทยาการคอมพิวเตอร์และสารสนเทศ",
    4: "วท.บ.ชีววิทยาศาสตร์",
    5: "วท.บ.คณิตศาสตร์และการจัดการข้อมูล ร่วมกับ\nวท.บ.วิทยาการคอมพิวเตอร์และสารสนเทศ"
  };
  final List<String> _years = [
    'All',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027'
  ];
  String? _selectedYear = 'All';

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
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'สรุปยอดแต่ละสาขา',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  hint: Text('Select Year'),
                  value: _selectedYear,
                  items: _years.map((String year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedYear = newValue;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            if (_isLoading)
              CircularProgressIndicator() // Loading indicator
            else if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              )
            else
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections(),
                  ),
                ),
              ),
            SizedBox(width: 8), // Add space between chart and labels
            _buildMajorLabels(),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    Map<int, int> majorCounts = _calculateStudentCounts();
    return majorCounts.entries.map((entry) {
      final isTouched = entry.key == 2; // Example: Highlight the third major
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = Colors.primaries[entry.key % Colors.primaries.length];

      return PieChartSectionData(
        color: color,
        value: entry.value.toDouble(),
        title: '${entry.value}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Map<int, int> _calculateStudentCounts() {
    Map<int, int> counts = {};

    for (var major in _Majors.keys) {
      counts[major] = 0;
    }

    for (var student in _students) {
      if (_selectedYear == 'All') {
        // Count all students regardless of year
        counts[student.stdInfo.major] =
            (counts[student.stdInfo.major] ?? 0) + 1;
      } else {
        String prefix = _getYearPrefix(_selectedYear);
        if (student.stdInfo.stdId.startsWith(prefix)) {
          // Count students based on year prefix
          counts[student.stdInfo.major] =
              (counts[student.stdInfo.major] ?? 0) + 1;
        }
      }
    }
    return counts;
  }

  String _getYearPrefix(String? year) {
    switch (year) {
      case '2022':
        return '65';
      case '2023':
        return '66';
      case '2024':
        return '67';
      case '2025':
        return '68';
      case '2026':
        return '69';
      case '2027':
        return '70';
      default:
        return '';
    }
  }

  Widget _buildMajorLabels() {
    Map<int, int> majorCounts = _calculateStudentCounts();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          majorCounts.entries.where((entry) => entry.value > 0).map((entry) {
        final color = Colors.primaries[entry.key % Colors.primaries.length];
        return Row(
          children: [
            Container(
              width: 20,
              height: 20,
              color: color,
            ),
            SizedBox(width: 8),
            Text(
              '${_Majors[entry.key]}: ${entry.value}', // Major name and count
              style: TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }
}
