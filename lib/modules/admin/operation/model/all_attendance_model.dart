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
      data = (json['data'] as List)
          .map((v) => IndividualUserAttendance.fromJson(v ?? {}))
          .toList();
    } else {
      data = [];
    }
    message = json['message'] ?? '';
  }
}

class IndividualUserAttendance {
  int? userId;
  String? name;
  String? email;
  String? companyId;
  String? martName;
  String? categoryName;
  List<AttendanceRecords>? attendanceRecords;

  IndividualUserAttendance({
    this.userId,
    this.name,
    this.email,
    this.companyId,
    this.categoryName,
    this.martName,
    this.attendanceRecords,
  });

  IndividualUserAttendance.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] ?? 0;
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    companyId = json['company_id']?.toString() ?? '';
    martName = json['mart_name']?.toString() ?? '';
    categoryName = json['category_name']?.toString() ?? '';

    if (json['attendance_records'] != null &&
        json['attendance_records'] is List) {
      attendanceRecords = (json['attendance_records'] as List)
          .map((v) => AttendanceRecords.fromJson(v ?? {}))
          .toList();
    } else {
      attendanceRecords = [];
    }
  }
}

class AttendanceRecords {
  String? date;
  String? status;
  String? checkinTime;
  String? checkoutTime;
  String? imageIn;
  String? imageOut;
  String? lat;
  String? lng;

  AttendanceRecords({
    this.date,
    this.status,
    this.checkinTime,
    this.checkoutTime,
    this.imageIn,
    this.imageOut,
    this.lat,
    this.lng,
  });

  AttendanceRecords.fromJson(Map<String, dynamic> json) {
    date = json['date'] ?? '';
    status = json['status'] ?? '';
    checkinTime = json['checkin_time'] ?? '';
    checkoutTime = json['checkout_time'] ?? '';
    imageIn = json['image_in'] ?? '';
    imageOut = json['image_out'] ?? '';
    lat = json['lat']?.toString() ?? '0.0';
    lng = json['lng']?.toString() ?? '0.0';
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'status': status,
      'checkin_time': checkinTime,
      'checkout_time': checkoutTime,
      'image_in': imageIn,
      'image_out': imageOut,
      'lat': lat,
      'lng': lng,
    };
  }
}
