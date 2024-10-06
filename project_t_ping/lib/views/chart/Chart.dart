import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project_t_ping/controllers/std_Controller.dart';
import 'package:project_t_ping/models/std_model.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:provider/provider.dart';

class MyChart extends StatefulWidget {
  const MyChart({super.key});

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  List<studentInfo> _students = [];

  bool isSearching = false;
  bool _isLoading = true;
  String? _errorMessage;

  final Map<int, String> _ThaiProvinces = {
    1: 'กรุงเทพมหานคร',
    2: 'กระบี่',
    3: 'กาญจนบุรี',
    4: 'บุรีรัมย์',
    5: 'ชัยภูมิ',
    6: 'ชลบุรี',
    7: 'เชียงใหม่',
    8: 'เชียงราย',
    9: 'ตรัง',
    10: 'ตราด',
    11: 'ตาก',
    12: 'นครนายก',
    13: 'นครปฐม',
    14: 'นครราชสีมา',
    15: 'นครศรีธรรมราช',
    16: 'นนทบุรี',
    17: 'บึงกาฬ',
    18: 'บุรีรัมย์',
    19: 'ปทุมธานี',
    20: 'ประจวบคีรีขันธ์',
    21: 'ปัตตานี',
    22: 'พะเยา',
    23: 'พังงา',
    24: 'พัทลุง',
    25: 'ภูเก็ต',
    26: 'มหาสารคาม',
    27: 'มุกดาหาร',
    28: 'ยโสธร',
    29: 'ระนอง',
    30: 'ระยอง',
    31: 'ราชบุรี',
    32: 'ลพบุรี',
    33: 'ลำปาง',
    34: 'ลำพูน',
    35: 'เลย',
    36: 'ศรีสะเกษ',
    37: 'สกลนคร',
    38: 'สงขลา',
    39: 'สมุทรปราการ',
    40: 'สมุทรสาคร',
    41: 'สระบุรี',
    42: 'สิงห์บุรี',
    43: 'สุโขทัย',
    44: 'สุพรรณบุรี',
    45: 'สุราษฎร์ธานี',
    46: 'สุรินทร์',
    47: 'อำนาจเจริญ',
    48: 'อุดรธานี',
    49: 'อุตรดิตถ์',
    50: 'อุบลราชธานี',
    51: 'เชียงราย',
    52: 'นครสวรรค์',
    53: 'เพชรบูรณ์',
    54: 'พิจิตร',
    55: 'เพชรบุรี',
    56: 'แพร่',
    57: 'ลำปาง',
    58: 'แม่ฮ่องสอน',
    59: 'น่าน',
    60: 'ศรีสะเกษ',
    61: 'พิจิตร',
    62: 'นครราชสีมา',
    63: 'บุรีรัมย์',
    64: 'สุรินทร์',
    65: 'ยโสธร',
    66: 'ขอนแก่น',
    67: 'กาฬสินธุ์',
    68: 'มุกดาหาร',
    69: 'กาฬสินธุ์',
    70: 'หนองคาย',
    71: 'อุดรธานี',
    72: 'บึงกาฬ',
    73: 'นครพนม',
    74: 'สกลนคร',
    75: 'เลย',
    76: 'พะเยา',
    77: 'อำนาจเจริญ',
  };

  String? getProvinceName(int provinceId) {
    return _ThaiProvinces[provinceId];
  }

  void _fetchAllstudents() async {
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
    _fetchAllstudents();
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
                  'สรุปยอดนิสิต\nแต่ละจังหวัด',
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
              Center(child: CircularProgressIndicator())
            else if (_errorMessage != null)
              Center(
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
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
            SizedBox(
              height: 8,
            ),
            _buildProvinceLabels(),
          ],
        ),
      ),
    );
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

  Map<int, int> _calculateStudentCounts() {
    Map<int, int> counts = {};
    for (var provinceId in _ThaiProvinces.keys) {
      counts[provinceId] = 0;
    }
    for (var student in _students) {
      if (_selectedYear == 'All') {
        counts[student.stdInfo.school.schProvince] =
            (counts[student.stdInfo.school.schProvince] ?? 0) + 1;
      } else {
        String prefix = _getYearPrefix(_selectedYear);
        if (student.stdInfo.stdId.startsWith(prefix)) {
          counts[student.stdInfo.school.schProvince] =
              (counts[student.stdInfo.school.schProvince] ?? 0) + 1;
        }
      }
    }
    return counts;
  }

  List<PieChartSectionData> showingSections() {
    Map<int, int> ProvinceCounts = _calculateStudentCounts();
    return ProvinceCounts.entries.map((entry) {
      final isTouched = entry.key == 2;
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

  Widget _buildProvinceLabels() {
    Map<int, int> provinceCounts = _calculateStudentCounts();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          provinceCounts.entries.where((entry) => entry.value > 0).map((entry) {
        final provinceName = getProvinceName(entry.key);
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
              '$provinceName: ${entry.value}',
              style: TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }
}
