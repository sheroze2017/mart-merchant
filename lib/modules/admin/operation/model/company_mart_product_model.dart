class AllCompanyProductData {
  int? code;
  bool? success;
  List<ProductCMData>? data;
  String? message;

  AllCompanyProductData({
    this.code,
    this.success,
    this.data,
    this.message,
  });

  AllCompanyProductData.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    success = json['success'] ?? false;
    if (json['data'] != null && json['data'] is List) {
      data = List<ProductCMData>.from(
          json['data'].map((item) => ProductCMData.fromJson(item)));
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
    jsonData['message'] = message;
    return jsonData;
  }
}

class ProductCMData {
  int? productId;
  int? companyId;
  String? productName;
  String? variant;
  String? productDesc;
  String? price;
  String? status;
  String? createdAt;
  String? qty;
  int? martId;
  int? categoryId;
  String? sizes;

  ProductCMData({
    this.productId,
    this.companyId,
    this.productName,
    this.variant,
    this.productDesc,
    this.price,
    this.status,
    this.createdAt,
    this.qty,
    this.martId,
    this.categoryId,
    this.sizes,
  });

  ProductCMData.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'] ?? 0;
    companyId = json['company_id'] ?? 0;
    productName = json['product_name'] ?? '';
    variant = json['variant'] ?? '';
    productDesc = json['product_desc'] ?? '';
    price = json['price'] ?? '';
    status = json['status'].toString() ?? '';
    createdAt = json['created_at'] ?? '';
    qty = json['qty'] ?? '';
    martId = json['mart_id'] ?? 0;
    categoryId = json['category_id'] ?? 0;
    sizes = json['sizes'].toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData['product_id'] = productId;
    jsonData['company_id'] = companyId;
    jsonData['product_name'] = productName ?? '';
    jsonData['variant'] = variant ?? '';
    jsonData['product_desc'] = productDesc ?? '';
    jsonData['price'] = price ?? '';
    jsonData['status'] = status ?? '';
    jsonData['created_at'] = createdAt ?? '';
    jsonData['qty'] = qty ?? '';
    jsonData['mart_id'] = martId;
    jsonData['category_id'] = categoryId;
    jsonData['sizes'] = sizes ?? '';
    return jsonData;
  }
}
