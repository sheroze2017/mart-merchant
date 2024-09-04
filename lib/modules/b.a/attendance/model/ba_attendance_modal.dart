class Attendance {
  final String date;
  final String checkInTime;
  final String checkOutTime;
  final bool status;

  Attendance({
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      date: json['date'],
      checkInTime: json['checkInTime'],
      checkOutTime: json['checkOutTime'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'status': status,
    };
  }
}
