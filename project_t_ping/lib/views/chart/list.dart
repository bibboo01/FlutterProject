import 'package:flutter/material.dart';
import 'package:project_t_ping/controllers/std_Controller.dart';
import 'package:project_t_ping/models/std_model.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:provider/provider.dart';

class ListCard extends StatefulWidget {
  const ListCard({Key? key}) : super(key: key);

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  final TextEditingController _searchController = TextEditingController();
  // Controllers สำหรับฟิลด์ฟอร์มแต่ละตัว
  final _formKey = GlobalKey<FormState>();
  final _stdIdController = TextEditingController();
  final _stdFnameController = TextEditingController();
  final _stdLnameController = TextEditingController();
  final _stdNicknameController = TextEditingController();
  final _stdTelController = TextEditingController();
  final _schNameController = TextEditingController();
  final _schProvinceController = TextEditingController();
  final _stdFatherNameController = TextEditingController();
  final _stdFatherTelController = TextEditingController();
  final _stdMotherNameController = TextEditingController();
  final _stdMotherTelController = TextEditingController();
  final _stdParentNameController = TextEditingController();
  final _stdParentTelController = TextEditingController();
  final _stdParentRelaController = TextEditingController();
  final _allergicThingsController = TextEditingController();
  final _allergicDrugsController = TextEditingController();
  final _allergicConditionController = TextEditingController();

  // ตัวแปรเก็บค่าที่เลือก
  int? _selectedMajor;
  int? _selectedReligion;
  int? _selectedPrefix;
  int? _selectedProvince;

  List<studentInfo> _students = [];
  List<studentInfo> filteredStudents = [];

  bool isSearching = false;
  bool _isLoading = true;
  String? _errorMessage;

  int _currentPage = 0; // Track the current page
  final int _itemsPerPage = 6; // Items per page

  // ตัวแปรเก็บค่าที่เลือก

  final Map<int, String> _Majors = {
    0: "วท.บ.เคมี",
    1: "วท.บ.วิทยาศาสตร์สิ่งแวดล้อม",
    2: "วท.บ.คณิตศาสตร์และการจัดการข้อมูล",
    3: "วท.บ.วิทยาการคอมพิวเตอร์และสารสนเทศ",
    4: "วท.บ.ชีววิทยาศาสตร์",
    5: "วท.บ.คณิตศาสตร์และการจัดการข้อมูล ร่วมกับ วท.บ.วิทยาการคอมพิวเตอร์และสารสนเทศ"
  };

  final Map<int, String> _Religions = {
    0: "คริสต์",
    1: "อิสลาม",
    2: "พุทธ",
    3: "ฮินดู"
  };

  final Map<int, String> _Prefix = {0: "นาย", 1: "นางสาว"};

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

  void _fetchAllstudents() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;
    try {
      final allStudents =
          await StdInfo().fetchStd(context, accessToken!, refreshToken!);
      setState(() {
        _students = allStudents;
        filteredStudents = List.from(_students);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void post_std() async {
    final stdId = _stdIdController.text;
    final stdFname = _stdFnameController.text;
    final stdLname = _stdLnameController.text;
    final stdNickname = _stdNicknameController.text;
    final stdTel = _stdTelController.text;
    final schName = _schNameController.text;
    final stdFatherName = _stdFatherNameController.text;
    final stdFatherTel = _stdFatherTelController.text;
    final stdMotherName = _stdMotherNameController.text;
    final stdMotherTel = _stdMotherTelController.text;
    final stdParentName = _stdParentNameController.text;
    final stdParentTel = _stdParentTelController.text;
    final stdParentRela = _stdParentRelaController.text;
    final allergicThings = _allergicThingsController.text;
    final allergicDrugs = _allergicDrugsController.text;
    final allergicCondition = _allergicConditionController.text;

    // Use null-aware operators and default values to prevent null exceptions
    final int major = _selectedMajor ?? 0;
    final int religion = _selectedReligion ?? 0;
    final int prefix = _selectedPrefix ?? 0;
    final int Province = _selectedProvince ?? 0;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;

    try {
      final result = await StdInfo().add_info(
          context,
          stdId,
          prefix,
          stdFname,
          stdLname,
          stdNickname,
          religion,
          major,
          stdTel,
          schName,
          Province,
          stdFatherName,
          stdFatherTel,
          stdMotherName,
          stdMotherTel,
          stdParentName,
          stdParentTel,
          stdParentRela,
          allergicThings,
          allergicDrugs,
          allergicCondition,
          accessToken!,
          refreshToken!);
      if (result == null) {
        Navigator.of(context).pop();
        _showSuccessDialog();
        _fetchAllstudents();
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    result)) // Display the error message from the addstudent function
            );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed. Please try again.')),
      );
    }
  }

  void _clearForm() {
    _stdIdController.clear();
    _stdFnameController.clear();
    _stdLnameController.clear();
    _stdNicknameController.clear();
    _stdTelController.clear();
    _schNameController.clear();
    _schProvinceController.clear();
    _stdFatherNameController.clear();
    _stdFatherTelController.clear();
    _stdMotherNameController.clear();
    _stdMotherTelController.clear();
    _stdParentNameController.clear();
    _stdParentTelController.clear();
    _stdParentRelaController.clear();
    _allergicThingsController.clear();
    _allergicDrugsController.clear();
    _allergicConditionController.clear();
    setState(() {
      _selectedMajor = null;
      _selectedReligion = null;
      _selectedPrefix = null;
    });
  }

  void _filterStudents(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredStudents = _students;
        isSearching = false;
      });
    } else {
      final filteredList = _students.where((student) {
        return student.stdInfo.stdFname
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            student.stdInfo.stdLname
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            student.stdInfo.stdId.contains(query);
      }).toList();
      setState(() {
        filteredStudents = filteredList;
        _currentPage = 0;
      });
    }
  }

  String? _prefix(int prefix) {
    return _Prefix[prefix];
  }

  String? _religion(int religion) {
    return _Religions[religion];
  }

  String? _major(int major) {
    return _Majors[major];
  }

  String? getProvinceName(int provinceId) {
    return _ThaiProvinces[provinceId];
  }

  @override
  void initState() {
    super.initState();
    _fetchAllstudents();
  }

  Future<void> _deleteStudent(String stdid) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this ID: $stdid?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await StdInfo().delstd(context, stdid, accessToken!, refreshToken!);
        _fetchAllstudents();
        Navigator.of(context).pop();
      } catch (e) {
        print('Error deleting student: $e');
      }
    }
  }

  Future<void> _editStudentDetails(studentInfo student) async {
    final TextEditingController stdIdController =
        TextEditingController(text: student.stdInfo.stdId);
    final TextEditingController fnameController =
        TextEditingController(text: student.stdInfo.stdFname);
    final TextEditingController lnameController =
        TextEditingController(text: student.stdInfo.stdLname);
    final TextEditingController nicknameController =
        TextEditingController(text: student.stdInfo.stdNickname);
    final TextEditingController telController =
        TextEditingController(text: student.stdInfo.stdTel);
    final TextEditingController schNameController =
        TextEditingController(text: student.stdInfo.school.schName);
    final TextEditingController fatherNameController =
        TextEditingController(text: student.stdInfo.details.stdFatherName);
    final TextEditingController fatherTelController =
        TextEditingController(text: student.stdInfo.details.stdFatherTel);
    final TextEditingController motherNameController =
        TextEditingController(text: student.stdInfo.details.stdMotherName);
    final TextEditingController motherTelController =
        TextEditingController(text: student.stdInfo.details.stdMotherTel);
    final TextEditingController parentNameController =
        TextEditingController(text: student.stdInfo.details.stdParentName);
    final TextEditingController parentTelController =
        TextEditingController(text: student.stdInfo.details.stdParentTel);
    final TextEditingController parentRelaController =
        TextEditingController(text: student.stdInfo.details.stdParentRela);
    final TextEditingController allergicThingsController =
        TextEditingController(text: student.stdInfo.details.allergicThings);
    final TextEditingController allergicDrugsController =
        TextEditingController(text: student.stdInfo.details.allergicDrugs);
    final TextEditingController allergicConditionController =
        TextEditingController(text: student.stdInfo.details.allergicCondition);

    int? _selectedMajor = student.stdInfo.major;
    int? _selectedReligion = student.stdInfo.stdReligion;
    int? _selectedPrefix = student.stdInfo.prefix;
    int? _selectedProvince = student.stdInfo.school.schProvince;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Student Details'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                buildTextField(
                    controller: stdIdController,
                    labelText: 'รหัสนิสิต',
                    readOnly: true),
                SizedBox(height: 8),
                _buildDropdown<int>(
                  label: 'เลือกคำนำหน้า',
                  items: _Prefix,
                  value: _selectedPrefix,
                  onChanged: (value) {
                    setState(() {
                      _selectedPrefix = value;
                    });
                  },
                ),
                SizedBox(height: 8),
                buildTextField(
                    controller: fnameController, labelText: 'First Name'),
                SizedBox(height: 8),
                buildTextField(
                    controller: lnameController, labelText: 'Last Name'),
                SizedBox(height: 8),
                buildTextField(
                    controller: nicknameController, labelText: 'Nickname'),
                SizedBox(height: 8),
                _buildDropdown<int>(
                  label: 'เลือกศาสนา', // "Select Religion"
                  items: _Religions,
                  value: _selectedReligion,
                  onChanged: (value) {
                    setState(() {
                      _selectedReligion = value;
                    });
                  },
                ),
                SizedBox(height: 8),
                _buildDropdown<int>(
                  label: 'เลือกวิชาเอก', // "Select Major"
                  items: _Majors,
                  value: _selectedMajor,
                  onChanged: (value) {
                    setState(() {
                      _selectedMajor = value;
                    });
                  },
                ),
                SizedBox(height: 8),
                buildTextField(
                    controller: telController,
                    labelText: 'Phone Number',
                    keyboardType: TextInputType.phone),
                SizedBox(height: 8),
                buildTextField(
                    controller: schNameController, labelText: 'School Name'),
                SizedBox(height: 8),
                _buildDropdown<int>(
                  label: 'เลือกจังหวัด', // "Select Major"
                  items: _ThaiProvinces,
                  value: _selectedProvince,
                  onChanged: (value) {
                    setState(() {
                      _selectedProvince = value;
                    });
                  },
                ),
                SizedBox(height: 8),
                buildTextField(
                    controller: fatherNameController,
                    labelText: 'Father\'s Name'),
                SizedBox(height: 8),
                buildTextField(
                    controller: fatherTelController,
                    labelText: 'Father\'s Phone'),
                SizedBox(height: 8),
                buildTextField(
                    controller: motherNameController,
                    labelText: 'Mother\'s Name'),
                SizedBox(height: 8),
                buildTextField(
                    controller: motherTelController,
                    labelText: 'Mother\'s Phone'),
                SizedBox(height: 8),
                buildTextField(
                    controller: parentNameController,
                    labelText: 'Guardian\'s Name'),
                SizedBox(height: 8),
                buildTextField(
                    controller: parentTelController,
                    labelText: 'Guardian\'s Phone'),
                SizedBox(height: 8),
                buildTextField(
                    controller: parentRelaController,
                    labelText: 'Relationship'),
                SizedBox(height: 8),
                buildTextField(
                    controller: allergicThingsController,
                    labelText: 'Allergic Things'),
                SizedBox(height: 8),
                buildTextField(
                    controller: allergicDrugsController,
                    labelText: 'Allergic Drugs'),
                SizedBox(height: 8),
                buildTextField(
                    controller: allergicConditionController,
                    labelText: 'Allergic Condition'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String stdId = stdIdController.text;
                int prefix = _selectedPrefix!;
                String stdFname = fnameController.text;
                String stdLname = lnameController.text;
                String stdNickname = nicknameController.text;
                int stdReligion = _selectedReligion!;
                int major = _selectedMajor!;
                String stdTel = telController.text;
                String schName = schNameController.text;
                int schProvince = _selectedProvince!;
                String stdFatherName = fatherNameController.text;
                String stdFatherTel = fatherTelController.text;
                String stdMotherName = motherNameController.text;
                String stdMotherTel = motherTelController.text;
                String stdParentName = parentNameController.text;
                String stdParentTel = parentTelController.text;
                String stdParentRela = parentRelaController.text;
                String allergicThings = allergicThingsController.text;
                String allergicDrugs = allergicDrugsController.text;
                String allergicCondition = allergicConditionController.text;
                await _edit(
                    stdId,
                    prefix,
                    stdFname,
                    stdLname,
                    stdNickname,
                    stdReligion,
                    major,
                    stdTel,
                    schName,
                    schProvince,
                    stdFatherName,
                    stdFatherTel,
                    stdMotherName,
                    stdMotherTel,
                    stdParentName,
                    stdParentTel,
                    stdParentRela,
                    allergicThings,
                    allergicDrugs,
                    allergicCondition);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _edit(
    String stdId,
    int prefix,
    String stdFname,
    String stdLname,
    String stdNickname,
    int stdReligion,
    int major,
    String stdTel,
    String schName,
    int schProvince,
    String stdFatherName,
    String stdFatherTel,
    String stdMotherName,
    String stdMotherTel,
    String stdParentName,
    String stdParentTel,
    String stdParentRela,
    String allergicThings,
    String allergicDrugs,
    String allergicCondition,
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;
    try {
      await StdInfo().editstudents(
          context,
          stdId,
          prefix,
          stdFname,
          stdLname,
          stdNickname,
          stdReligion,
          major,
          stdTel,
          schName,
          schProvince,
          stdFatherName,
          stdFatherTel,
          stdMotherName,
          stdMotherTel,
          stdParentName,
          stdParentTel,
          stdParentRela,
          allergicThings,
          allergicDrugs,
          allergicCondition,
          accessToken!,
          refreshToken!);
      _fetchAllstudents();
      Navigator.of(context).pop();
    } catch (e) {
      print('Error deleting student: $e');
    }
  }

  void _detailStudent(studentInfo student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'รายละเอียดนิสิต',
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Row(
                  children: [
                    TextButton(
                        child: Icon(Icons.clear),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        })
                  ],
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Center(child: Text("ข้อมูลนิสิต")),
                SizedBox(height: 8),
                Text("รหัสนิสิต: ${student.stdInfo.stdId}"),
                SizedBox(height: 8),
                Text(
                    "ชื่อ-นามสกุล: ${_prefix(student.stdInfo.prefix)}${student.stdInfo.stdFname} ${student.stdInfo.stdLname}"),
                SizedBox(height: 8),
                Text("ชื่อเล่น: ${student.stdInfo.stdNickname}"),
                SizedBox(height: 8),
                Text("ศาสนา: ${_religion(student.stdInfo.stdReligion)}"),
                SizedBox(height: 8),
                Text("วิชาเอก: ${_major(student.stdInfo.major)}"),
                SizedBox(height: 8),
                Text("เบอร์โทร: ${student.stdInfo.stdTel}"),
                SizedBox(height: 8),
                Center(child: Text("ข้อมูลครอบครัว")),
                SizedBox(height: 8),
                Text("ชื่อบิดา: ${student.stdInfo.details.stdFatherName}"),
                SizedBox(height: 8),
                Text("เบอร์โทร: ${student.stdInfo.details.stdFatherTel}"),
                SizedBox(height: 8),
                Text("ชื่อมารดา: ${student.stdInfo.details.stdMotherName}"),
                SizedBox(height: 8),
                Text("เบอร์โทร: ${student.stdInfo.details.stdMotherTel}"),
                SizedBox(height: 8),
                Text("ชื่อผู้ปกครอง: ${student.stdInfo.details.stdParentName}"),
                SizedBox(height: 8),
                Text("เบอร์โทร: ${student.stdInfo.details.stdParentTel}"),
                SizedBox(height: 8),
                Text("ความสัมพัมธ์: ${student.stdInfo.details.stdParentRela}"),
                SizedBox(height: 8),
                Center(child: Text("ข้อมูลทางการแพทย์")),
                SizedBox(height: 8),
                Text("สิ่งที่แพ้: ${student.stdInfo.details.allergicThings}"),
                SizedBox(height: 8),
                Text("ยาที่แพ้: ${student.stdInfo.details.allergicDrugs}"),
                SizedBox(height: 8),
                Text(
                    "ประวัติทางการแพทย์: ${student.stdInfo.details.allergicCondition}"),
                SizedBox(height: 8),
                Center(child: Text("ข้อมูลโรงเรียนที่จบ")),
                SizedBox(height: 8),
                Text("ชื่อโรงเรียน: ${student.stdInfo.school.schName}"),
                SizedBox(height: 8),
                Text(
                    "จังหวัด: ${getProvinceName(student.stdInfo.school.schProvince)}"),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      child: Text('Edit'),
                      onPressed: () async {
                        await _editStudentDetails(student);
                      },
                    ),
                    ElevatedButton(
                      child: Text('Delete'),
                      onPressed: () async {
                        await _deleteStudent(student.stdInfo.stdId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    filteredStudents.sort((a, b) => a.stdInfo.stdId.compareTo(b.stdInfo.stdId));

    final int totalPages = (filteredStudents.length / _itemsPerPage).ceil();
    // Get the items for the current page
    final List<studentInfo> currentPageStudents = filteredStudents
        .skip(_currentPage * _itemsPerPage)
        .take(_itemsPerPage)
        .toList();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'รายชื่อนิสิต',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        _showAddStudentDialog();
                      },
                      icon: Icon(Icons.add_box)),
                ],
              ),
              SizedBox(height: 16), // Add spacing
              TextField(
                controller: _searchController,
                onChanged: _filterStudents,
                decoration: InputDecoration(
                  labelText: 'Search Students',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16), // Add spacing
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : currentPageStudents.isEmpty // Check for filtered list
                          ? Center(
                              child: studentListCard(
                              searchController: _searchController,
                              isLoading: _isLoading,
                              errorMessage: _errorMessage,
                              students: _students,
                              onStudentTap: _detailStudent,
                              onSearchChanged: _filterStudents,
                            ))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  NeverScrollableScrollPhysics(), // Prevent scrolling
                              itemCount: currentPageStudents
                                  .length, // Use filtered list
                              itemBuilder: (context, index) {
                                final student = currentPageStudents[index];
                                return ListTile(
                                    title: Text(
                                      "ชื่อ ${student.stdInfo.stdFname} ${student.stdInfo.stdLname}",
                                    ),
                                    subtitle: Text(
                                        'รหัสนิสิต: ${student.stdInfo.stdId}'),
                                    trailing: IconButton(
                                        onPressed: () {
                                          _detailStudent(student);
                                        },
                                        icon: Icon(Icons.article)));
                              },
                            ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _currentPage > 0
                        ? () {
                            setState(() {
                              _currentPage--;
                            });
                          }
                        : null,
                    child: Text('Previous'),
                  ),
                  ElevatedButton(
                    onPressed: _currentPage < totalPages - 1
                        ? () {
                            setState(() {
                              _currentPage++;
                            });
                          }
                        : null,
                    child: Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLength: maxLength,
    );
  }

  DropdownButtonFormField<T> _buildDropdown<T>({
    required String label,
    required Map<int, String> items,
    required T? value,
    required ValueChanged<T?>? onChanged,
  }) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      value: value,
      hint: Text('กรุณาเลือก $label'), // "Please select $label"
      items: items.entries
          .map((entry) => DropdownMenuItem<T>(
                value: entry.key as T,
                child: Text(entry.value),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget studentListCard({
    required TextEditingController searchController,
    required bool isLoading,
    String? errorMessage,
    required List<studentInfo> students,
    required Function(studentInfo) onStudentTap,
    required Function(String) onSearchChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(child: Text(errorMessage))
                    : students.isEmpty // Check for empty list
                        ? Center(child: Text('No students found.'))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics:
                                NeverScrollableScrollPhysics(), // Prevent scrolling
                            itemCount: students.length,
                            itemBuilder: (context, index) {
                              final student = students[index];
                              return ListTile(
                                title: Text(
                                  "ชื่อ ${student.stdInfo.stdFname} ${student.stdInfo.stdLname}",
                                ),
                                subtitle:
                                    Text('รหัสนิสิต: ${student.stdInfo.stdId}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.article),
                                  onPressed: () {
                                    onStudentTap(student);
                                  },
                                ),
                              );
                            },
                          ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Successful'),
          actions: <Widget>[
            TextButton(
              child: Center(child: Text('OK')),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddStudentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Student',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Student ID
                  _buildTextField(
                    _stdIdController,
                    'รหัสนิสิต',
                    'กรุณากรอกรหัสนิสิต',
                    TextInputType.number,
                    maxLength: 10,
                  ),
                  // Prefix
                  _buildDropdownForForm(
                    'คำนำหน้า',
                    _Prefix,
                    _selectedPrefix,
                    (value) {
                      setState(() {
                        _selectedPrefix = value;
                      });
                    },
                  ),
                  // First Name
                  _buildTextField(
                    _stdFnameController,
                    'ชื่อ',
                    'กรุณากรอกชื่อ',
                    TextInputType.text,
                    maxLength: 50,
                  ),
                  // Last Name
                  _buildTextField(
                    _stdLnameController,
                    'นามสกุล',
                    'กรุณากรอกนามสกุล',
                    TextInputType.text,
                    maxLength: 50,
                  ),
                  // Nickname
                  _buildTextField(
                    _stdNicknameController,
                    'ชื่อเล่น',
                    null,
                    TextInputType.text,
                    maxLength: 20,
                  ),
                  // Telephone
                  _buildTextField(
                    _stdTelController,
                    'เบอร์โทรศัพท์',
                    'กรุณากรอกเบอร์โทรศัพท์',
                    TextInputType.phone,
                    maxLength: 10,
                  ),
                  // Religion
                  _buildDropdownForForm(
                    'ศาสนา',
                    _Religions,
                    _selectedReligion,
                    (value) {
                      setState(() {
                        _selectedReligion = value;
                      });
                    },
                  ),
                  // Major
                  _buildDropdownForForm(
                    'วิชาเอก',
                    _Majors,
                    _selectedMajor,
                    (value) {
                      setState(() {
                        _selectedMajor = value;
                      });
                    },
                  ),
                  // School Name
                  _buildTextField(
                    _schNameController,
                    'ชื่อโรงเรียนที่สำเร็จการศึกษา',
                    'กรุณากรอกชื่อโรงเรียนรที่สำเร็จการศึกษา',
                    TextInputType.text,
                    maxLength: 50,
                  ),
                  // School Province
                  _buildProvinceDropdown(
                    _selectedProvince,
                    (value) {
                      setState(() {
                        _selectedProvince = value;
                      });
                    },
                  ),
                  // Father's Name
                  _buildTextField(
                    _stdFatherNameController,
                    'ชื่อบิดา',
                    null,
                    TextInputType.text,
                    maxLength: 50,
                  ),
                  // Father's Telephone
                  _buildTextField(
                    _stdFatherTelController,
                    'เบอร์โทรศัพท์',
                    null,
                    TextInputType.phone,
                    maxLength: 10,
                  ),
                  // Mother's Name
                  _buildTextField(
                    _stdMotherNameController,
                    'ชื่อมารดา',
                    null,
                    TextInputType.text,
                    maxLength: 50,
                  ),
                  // Mother's Telephone
                  _buildTextField(
                    _stdMotherTelController,
                    'เบอร์โทรศัพท์',
                    null,
                    TextInputType.phone,
                    maxLength: 10,
                  ),
                  // Parent's Name
                  _buildTextField(
                    _stdParentNameController,
                    'ชื่อผู้ปกครอง',
                    null,
                    TextInputType.text,
                    maxLength: 50,
                  ),
                  // Parent's Telephone
                  _buildTextField(
                    _stdParentTelController,
                    'เบอร์โทรศัพท์',
                    null,
                    TextInputType.phone,
                    maxLength: 10,
                  ),
                  // Parent's Relationship
                  _buildTextField(
                    _stdParentRelaController,
                    'ความสัมพันธ์ของนิสิต',
                    null,
                    TextInputType.text,
                    maxLength: 30,
                  ),
                  // Allergic to Things
                  _buildTextField(
                    _allergicThingsController,
                    'อาหารที่แพ้',
                    null,
                    TextInputType.text,
                    maxLength: 100,
                  ),
                  // Allergic to Drugs
                  _buildTextField(
                    _allergicDrugsController,
                    'ยาที่แพ้',
                    null,
                    TextInputType.text,
                    maxLength: 100,
                  ),
                  // Allergic Condition
                  _buildTextField(
                    _allergicConditionController,
                    'ประวัติการแพทย์',
                    null,
                    TextInputType.text,
                    maxLength: 100,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  post_std(); // Call your function to handle student addition
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันสำหรับสร้าง TextField
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String? validationMessage,
    TextInputType inputType, {
    int? maxLength, // New optional parameter
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          counterText: '', // Hide the character counter
        ),
        keyboardType: inputType,
        maxLength: maxLength, // Apply maxLength
        validator: (value) {
          if (validationMessage != null && (value == null || value.isEmpty)) {
            return validationMessage;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownForForm<T>(String label, Map<T, String> options,
      T? selectedValue, ValueChanged<T?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        value: selectedValue,
        hint: Text('กรุณาเลือก $label'), // "Please select $label"
        items: options.entries
            .map((entry) => DropdownMenuItem<T>(
                  value: entry.key,
                  child: Text(entry.value),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  DropdownButtonFormField<int> _buildProvinceDropdown(
      int? selectedValue, Function(int?)? onChanged) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: 'เลือกจังหวัด', // "Select Province" in Thai
        border: OutlineInputBorder(),
      ),
      value: selectedValue,
      hint: Text('กรุณาเลือกจังหวัด'), // "Please select a province"
      items: _ThaiProvinces.entries
          .map((entry) => DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
