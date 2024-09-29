class AllUserAttendance {
  int? code;
  bool? success;
  List<IndividualUserAttendance>? data;
  String? message;

  AllUserAttendance({this.code, this.success, this.data, this.message});

  AllUserAttendance.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    success = json['success'] ?? false;
    if (json['data'] != null && json['data'] is List) {
      data = <IndividualUserAttendance>[];
      json['data'].forEach((v) {
        data!.add(IndividualUserAttendance.fromJson(v ?? {}));
      });
    } else {
      data = [];
    }
    message = json['message'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class IndividualUserAttendance {
  int? userId;
  String? name;
  String? email;
  String? companyId;
  List<AttendanceRecords>? attendanceRecords;

  IndividualUserAttendance(
      {this.userId,
      this.name,
      this.email,
      this.companyId,
      this.attendanceRecords});

  IndividualUserAttendance.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] ?? 0;
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    companyId = json['company_id'] ?? '';
    if (json['attendance_records'] != null &&
        json['attendance_records'] is List) {
      attendanceRecords = <AttendanceRecords>[];
      json['attendance_records'].forEach((v) {
        attendanceRecords!.add(AttendanceRecords.fromJson(v ?? {}));
      });
    } else {
      attendanceRecords = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['company_id'] = this.companyId;
    if (this.attendanceRecords != null) {
      data['attendance_records'] =
          this.attendanceRecords!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendanceRecords {
  String? date;
  String? status;
  String? checkinTime;
  String? checkoutTime;

  AttendanceRecords(
      {this.date, this.status, this.checkinTime, this.checkoutTime});

  AttendanceRecords.fromJson(Map<String, dynamic> json) {
    date = json['date'] ?? '';
    status = json['status'] ?? '';
    checkinTime = json['checkin_time'] ?? '';
    checkoutTime = json['checkout_time'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = this.date;
    data['status'] = this.status;
    data['checkin_time'] = this.checkinTime;
    data['checkout_time'] = this.checkoutTime;
    return data;
  }
}
