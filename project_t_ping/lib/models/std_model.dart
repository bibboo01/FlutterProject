import 'dart:convert';

studentInfo welcomeFromJson(String str) =>
    studentInfo.fromJson(json.decode(str));

String welcomeToJson(studentInfo data) => json.encode(data.toJson());

class studentInfo {
  student stdInfo;

  studentInfo({required this.stdInfo});

  factory studentInfo.fromJson(Map<String, dynamic> json) => studentInfo(
        stdInfo: student.fromJson(json["std_info"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "std_info": stdInfo.toJson(),
      };
}

class student {
  String id;
  String stdId;
  int prefix;
  String stdFname;
  String stdLname;
  String stdNickname;
  int stdReligion;
  int major;
  String stdTel;
  Details details;
  School school;

  student({
    required this.id,
    required this.stdId,
    required this.prefix,
    required this.stdFname,
    required this.stdLname,
    required this.stdNickname,
    required this.stdReligion,
    required this.major,
    required this.stdTel,
    required this.details,
    required this.school,
  });

  factory student.fromJson(Map<String, dynamic> json) => student(
        id: json["_id"] ?? '',
        stdId: json["std_id"] ?? '',
        prefix: json["prefix"] ?? 0,
        stdFname: json["std_Fname"] ?? '',
        stdLname: json["std_Lname"] ?? '',
        stdNickname: json["std_nickname"] ?? '',
        stdReligion: json["std_religion"] ?? 0,
        major: json["major"] ?? 0,
        stdTel: json["std_tel"] ?? '',
        details: Details.fromJson(json["details"] ?? {}),
        school: School.fromJson(json["school"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "std_id": stdId,
        "prefix": prefix,
        "std_Fname": stdFname,
        "std_Lname": stdLname,
        "std_nickname": stdNickname,
        "std_religion": stdReligion,
        "major": major,
        "std_tel": stdTel,
        "details": details.toJson(),
        "school": school.toJson(),
      };
}

class Details {
  String id;
  String stdId;
  String stdFatherName;
  String stdFatherTel;
  String stdMotherName;
  String stdMotherTel;
  String stdParentName;
  String stdParentTel;
  String stdParentRela;
  String allergicThings;
  String allergicDrugs;
  String allergicCondition;

  Details({
    required this.id,
    required this.stdId,
    required this.stdFatherName,
    required this.stdFatherTel,
    required this.stdMotherName,
    required this.stdMotherTel,
    required this.stdParentName,
    required this.stdParentTel,
    required this.stdParentRela,
    required this.allergicThings,
    required this.allergicDrugs,
    required this.allergicCondition,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        id: json["_id"] ?? '',
        stdId: json["std_id"] ?? '',
        stdFatherName: json["std_father_name"] ?? '',
        stdFatherTel: json["std_father_tel"] ?? '',
        stdMotherName: json["std_mother_name"] ?? '',
        stdMotherTel: json["std_mother_tel"] ?? '',
        stdParentName: json["std_parent_name"] ?? '',
        stdParentTel: json["std_parent_tel"] ?? '',
        stdParentRela: json["std_parent_rela"] ?? '',
        allergicThings: json["allergic_things"] ?? '',
        allergicDrugs: json["allergic_drugs"] ?? '',
        allergicCondition: json["allergic_condition"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "std_id": stdId,
        "std_father_name": stdFatherName,
        "std_father_tel": stdFatherTel,
        "std_mother_name": stdMotherName,
        "std_mother_tel": stdMotherTel,
        "std_parent_name": stdParentName,
        "std_parent_tel": stdParentTel,
        "std_parent_rela": stdParentRela,
        "allergic_things": allergicThings,
        "allergic_drugs": allergicDrugs,
        "allergic_condition": allergicCondition,
      };
}

class School {
  String id;
  String stdId;
  String schName;
  int schProvince;

  School({
    required this.id,
    required this.stdId,
    required this.schName,
    required this.schProvince,
  });

  factory School.fromJson(Map<String, dynamic> json) => School(
        id: json["_id"] ?? '',
        stdId: json["std_id"] ?? '',
        schName: json["sch_name"] ?? '',
        schProvince: json["sch_province"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "std_id": stdId,
        "sch_name": schName,
        "sch_province": schProvince,
      };
}
