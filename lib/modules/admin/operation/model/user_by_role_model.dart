class AllUserByRole {
  int? code;
  bool? success;
  List<ByUserRoleData>? data;
  String? message;

  AllUserByRole({
    this.code,
    this.success,
    this.data,
    this.message,
  });

  AllUserByRole.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    success = json['success'] ?? false;
    if (json['data'] != null && json['data'] is List) {
      data = List<ByUserRoleData>.from(
          json['data'].map((item) => ByUserRoleData.fromJson(item)));
    } else {
      data = [];
    }
    message = json['message'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData['code'] = code;
    jsonData['success'] = success;
    if (data != null) {
      jsonData['data'] = data!.map((v) => v.toJson()).toList();
    }
    jsonData['message'] = message ?? '';
    return jsonData;
  }
}

class ByUserRoleData {
  int? userId;
  String? name;
  String? role;
  String? status;
  String? email;
  String? companyId;
  String? martId;
  String? categoryId;
  String? categoryName;

  // Main constructor with all parameters
  ByUserRoleData(
      {this.userId,
      this.name,
      this.role,
      this.status,
      this.email,
      this.companyId,
      this.categoryId,
      this.categoryName,
      this.martId});

  ByUserRoleData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] ?? 0;
    name = json['name'] ?? '';
    role = json['role'] ?? '';
    status = json['status'] ?? 'active';
    email = json['email'] ?? '';
    companyId = json['company_id'] ?? '';
    martId = json['mart_id'] ?? '';
    categoryName = json['category_name'] ?? '';
    categoryId = json['category_id'].toString();
  }

  // Method to convert Data object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData['user_id'] = userId ?? 0;
    jsonData['name'] = name ?? '';
    jsonData['role'] = role ?? '';
    jsonData['status'] = status ?? '';
    jsonData['category_name'] = categoryName ?? '';
    return jsonData;
  }
}
