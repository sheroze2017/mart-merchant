class AllMart {
  int? code;
  bool? success;
  List<MartData>? data;
  String? message;

  AllMart({
    this.code,
    this.success,
    this.data,
    this.message,
  });

  // Factory constructor to create an instance from JSON
  factory AllMart.fromJson(Map<String, dynamic> json) {
    return AllMart(
      code: json['code'] ?? 0, // Default value for code
      success: json['success'] ?? false, // Default to false if null
      data: json['data'] != null
          ? List<MartData>.from(
              json['data'].map((item) => MartData.fromJson(item)))
          : [], // If data is null, initialize as an empty list
      message: json['message'] ?? '', // Default empty string
    );
  }

  // Method to convert the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code ?? 0, // Default value for code
      'success': success ?? false, // Default to false if null
      'data': data?.map((item) => item.toJson()).toList() ??
          [], // Handle empty data
      'message': message ?? '', // Default empty string
    };
  }
}

class MartData {
  int? martId;
  String? martName;
  String? location;
  String? lat;
  String? lng;
  String? createdAt;
  String? status;

  MartData({
    this.martId,
    this.martName,
    this.location,
    this.lat,
    this.lng,
    this.createdAt,
    this.status,
  });

  // Factory constructor to create an instance from JSON
  factory MartData.fromJson(Map<String, dynamic> json) {
    return MartData(
      martId: json['mart_id'] ?? 0, // Default value for martId
      martName: json['mart_name'] ?? '', // Default empty string
      location: json['location'] ?? '', // Default empty string
      lat: json['lat'] ?? '', // Default empty string
      lng: json['lng'] ?? '', // Default empty string
      createdAt: json['created_at'] ?? '', // Default empty string
      status: json['status'] ?? '', // Default empty string
    );
  }

  // Method to convert the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'mart_id': martId ?? 0, // Default value for martId
      'mart_name': martName ?? '', // Default empty string
      'location': location ?? '', // Default empty string
      'lat': lat ?? '', // Default empty string
      'lng': lng ?? '', // Default empty string
      'created_at': createdAt ?? '', // Default empty string
      'status': status ?? '', // Default empty string
    };
  }
}
