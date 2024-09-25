class CreateUserModel {
  int? code;
  bool? success; 
  Data? data;
  String? message;

  CreateUserModel({this.code, this.success, this.data, this.message});

  CreateUserModel.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0; // Default to 0 if null
    success = json['success'] ?? false; // Default to false if null
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'] ?? ''; // Default to an empty string if null
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? userId;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? location;
  String? lat;
  String? lng;
  String? status;
  String? createdAt;
  String? role;
  String? image;
  String? martId;
  String? companyId;
  String? deviceToken;

  Data({
    this.userId,
    this.name,
    this.email,
    this.password,
    this.phone,
    this.location,
    this.lat,
    this.lng,
    this.status,
    this.createdAt,
    this.role,
    this.image,
    this.martId,
    this.companyId,
    this.deviceToken,
  });

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] ?? 0; // Default to 0 if null
    name = json['name'] ?? ''; // Default to empty string if null
    email = json['email'] ?? ''; // Default to empty string if null
    password = json['password'] ?? ''; // Default to empty string if null
    phone = json['phone'] ?? ''; // Default to empty string if null
    location = json['location'] ?? ''; // Default to empty string if null
    lat = json['lat'] ?? ''; // Default to empty string if null
    lng = json['lng'] ?? ''; // Default to empty string if null
    status = json['status'] ?? 'inactive'; // Default to 'inactive' if null
    createdAt = json['created_at'] ?? ''; // Default to empty string if null
    role = json['role'] ?? 'user'; // Default to 'user' if null
    image = json['image'] ?? ''; // Default to empty string if null
    martId = json['mart_id'] ?? ''; // Default to empty string if null
    companyId = json['company_id'] ?? ''; // Default to empty string if null
    deviceToken = json['device_token'] ?? ''; // Default to empty string if null
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['location'] = this.location;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['role'] = this.role;
    data['image'] = this.image;
    data['mart_id'] = this.martId;
    data['company_id'] = this.companyId;
    data['device_token'] = this.deviceToken;
    return data;
  }
}
