class AllCategoryModel {
  int? code;
  bool? sucess;
  List<CategoryData>? data;
  String? message;

  AllCategoryModel({this.code, this.sucess, this.data, this.message});

  AllCategoryModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(new CategoryData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['sucess'] = this.sucess;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class CategoryData {
  int? categoryId;
  int? companyId;
  String? name;
  String? status;
  String? createdAt;

  CategoryData(
      {this.categoryId,
      this.companyId,
      this.name,
      this.status,
      this.createdAt});

  CategoryData.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    companyId = json['company_id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}
