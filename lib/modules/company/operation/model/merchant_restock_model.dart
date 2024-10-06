class MerchantRestockDetailModel {
  int? code;
  bool? success;
  List<MerchantIndividualRestockDetail>? data;
  String? message;

  MerchantRestockDetailModel(
      {this.code, this.success, this.data, this.message});

  MerchantRestockDetailModel.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    success = json['success'] ?? false;
    if (json['data'] != null) {
      data = <MerchantIndividualRestockDetail>[];
      json['data'].forEach((v) {
        data!.add(MerchantIndividualRestockDetail.fromJson(v));
      });
    } else {
      data = [];
    }
    message = json['message'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code ?? 0;
    data['success'] = success ?? false;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    } else {
      data['data'] = [];
    }
    data['message'] = message ?? '';
    return data;
  }
}

class MerchantIndividualRestockDetail {
  int? merchantId;
  int? userId;
  String? image;
  String? remarks;
  String? lat;
  String? lng;
  String? status;
  String? createdAt;
  int? companyId;
  int? martId;
  MerchantDetails? merchantDetails;
  String? companyName;
  String? martName;

  MerchantIndividualRestockDetail(
      {this.merchantId,
      this.userId,
      this.image,
      this.remarks,
      this.lat,
      this.lng,
      this.status,
      this.createdAt,
      this.companyId,
      this.martId,
      this.merchantDetails,
      this.companyName,
      this.martName});

  MerchantIndividualRestockDetail.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchant_id'] ?? 0;
    userId = json['user_id'] ?? 0;
    image = json['image'] ?? '';
    remarks = json['remarks'] ?? '';
    lat = json['lat'] ?? '';
    lng = json['lng'] ?? '';
    status = json['status'] ?? '';
    createdAt = json['created_at'] ?? '';
    companyId = json['company_id'] ?? 0;
    martId = json['mart_id'] ?? 0;
    merchantDetails = json['merchant_details'] != null
        ? MerchantDetails.fromJson(json['merchant_details'])
        : null;
    companyName = json['company_name'] ?? '';
    martName = json['mart_name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchant_id'] = merchantId ?? 0;
    data['user_id'] = userId ?? 0;
    data['image'] = image ?? '';
    data['remarks'] = remarks ?? '';
    data['lat'] = lat ?? '';
    data['lng'] = lng ?? '';
    data['status'] = status ?? '';
    data['created_at'] = createdAt ?? '';
    data['company_id'] = companyId ?? 0;
    data['mart_id'] = martId ?? 0;
    if (merchantDetails != null) {
      data['merchant_details'] = merchantDetails!.toJson();
    }
    data['company_name'] = companyName ?? '';
    data['mart_name'] = martName ?? '';
    return data;
  }
}

class MerchantDetails {
  String? name;
  String? email;
  String? phone;

  MerchantDetails({this.name, this.email, this.phone});

  MerchantDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name ?? '';
    data['email'] = email ?? '';
    data['phone'] = phone ?? '';
    return data;
  }
}
