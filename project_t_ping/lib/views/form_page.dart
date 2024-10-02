import 'package:flutter/material.dart';
import 'package:project_t_ping/controllers/std_Controller.dart';
import 'package:project_t_ping/views/provider/userprovider.dart';
import 'package:provider/provider.dart';

class StdForm extends StatefulWidget {
  const StdForm({super.key});

  @override
  State<StdForm> createState() => _StdFormState();
}

class _StdFormState extends State<StdForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers สำหรับฟิลด์ฟอร์มแต่ละตัว
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

  // ตัวเลือกสำหรับ ChoiceChip
  final Map<int, String> _majors = {
    0: "วท.บ.เคมี",
    1: "วท.บ.วิทยาศาสตร์สิ่งแวดล้อม",
    2: "วท.บ.คณิตศาสตร์และการจัดการข้อมูล",
    3: "วท.บ.วิทยาการคอมพิวเตอร์และสารสนเทศ",
    4: "วท.บ.ชีววิทยาศาสตร์",
    5: "วท.บ.คณิตศาสตร์และการจัดการข้อมูล ร่วมกับ วท.บ.วิทยาการคอมพิวเตอร์และสารสนเทศ"
  };

  final Map<int, String> _religions = {
    0: "คริสต์",
    1: "อิสลาม",
    2: "พุทธ",
    3: "ฮินดู"
  };

  final Map<int, String> _prefix = {0: "นาย", 1: "นางสาว"};

  final Map<int, String> _thaiProvinces = {
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

  // ตัวแปรเก็บค่าที่เลือก
  int? _selectedMajor;
  int? _selectedReligion;
  int? _selectedPrefix;
  int? _selectedProvince;

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
      await StdInfo().add_info(
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

      // Handle success, e.g., parse response if needed
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Save successful!')));

      // Optionally clear the form fields
      _clearForm();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed. Please try again.')),
      );
    }
  }

// Method to clear form fields
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Information Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
              _buildChoiceChipField(
                'คำนำหน้า',
                _prefix,
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
              ),
              // Last Name
              _buildTextField(
                _stdLnameController,
                'นามสกุล',
                'กรุณากรอกนามสกุล',
                TextInputType.text,
              ),
              // Nickname
              _buildTextField(
                _stdNicknameController,
                'ชื่อเล่น',
                null,
                TextInputType.text,
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
              _buildChoiceChipField(
                'ศาสนา',
                _religions,
                _selectedReligion,
                (value) {
                  setState(() {
                    _selectedReligion = value;
                  });
                },
              ),
              // Major
              _buildChoiceChipField(
                'วิชาเอก',
                _majors,
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
              ),
              // Allergic to Things
              _buildTextField(
                _allergicThingsController,
                'อาหารที่แพ้',
                null,
                TextInputType.text,
              ),
              // Allergic to Drugs
              _buildTextField(
                _allergicDrugsController,
                'ยาที่แพ้',
                null,
                TextInputType.text,
              ),
              // Allergic Condition
              _buildTextField(
                _allergicConditionController,
                'ประวัติการแพทย์',
                null,
                TextInputType.text,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    post_std();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
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

  // ฟังก์ชันสำหรับสร้าง ChoiceChip
  Widget _buildChoiceChipField<T>(String label, Map<T, String> options,
      T? selectedValue, ValueChanged<T?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: options.entries.map((entry) {
              return ChoiceChip(
                label: Text(entry.value),
                selected: selectedValue == entry.key,
                onSelected: (bool selected) {
                  onChanged(selected ? entry.key : null);
                },
              );
            }).toList(),
          ),
        ],
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
      items: _thaiProvinces.entries
          .map((entry) => DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
