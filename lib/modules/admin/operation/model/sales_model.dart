class SalesModel {
  int? code;
  bool? sucess;
  List<IndividualSalesData>? data;
  String? message;

  SalesModel({this.code, this.sucess, this.data, this.message});

  SalesModel.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    sucess = json['sucess'] ?? false;
    if (json['data'] != null && json['data'] is List) {
      data = <IndividualSalesData>[];
      json['data'].forEach((v) {
        data!.add(IndividualSalesData.fromJson(v));
      });
    } else {
      data = [];
    }
    message = json['message'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = this.code;
    data['sucess'] = this.sucess;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class IndividualSalesData {
  int? saleId;
  String? createdAt;
  int? saleBy;
  int? companyId;
  int? martId;
  BA? bA;
  late List<ProductsSold> productsSold;
  String? companyName;
  String? martName;

  IndividualSalesData(
      {this.saleId,
      this.createdAt,
      this.saleBy,
      this.companyId,
      this.martId,
      this.bA,
      required this.productsSold,
      this.companyName,
      this.martName});

  IndividualSalesData.fromJson(Map<String, dynamic> json) {
    saleId = json['sale_id'] ?? 0;
    createdAt = json['created_at'] ?? '';
    saleBy = json['sale_by'] ?? 0;
    companyId = json['company_id'] ?? 0;
    martId = json['mart_id'] ?? 0;
    companyName = json['company_name'] ?? '';
    martName = json['mart_name'] ?? '';
    bA = json['BA'] != null ? BA.fromJson(json['BA']) : BA();
    if (json['products_sold'] != null && json['products_sold'] is List) {
      productsSold = <ProductsSold>[];
      json['products_sold'].forEach((v) {
        productsSold.add(ProductsSold.fromJson(v));
      });
    } else {
      productsSold = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['sale_id'] = this.saleId;
    data['created_at'] = this.createdAt;
    data['sale_by'] = this.saleBy;
    data['company_id'] = this.companyId;
    data['mart_id'] = this.martId;
    if (this.bA != null) {
      data['BA'] = this.bA!.toJson();
    }
    if (this.productsSold != null) {
      data['products_sold'] =
          this.productsSold!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BA {
  String? name;
  String? email;
  String? phone;

  BA({this.name, this.email, this.phone});

  BA.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}

class ProductsSold {
  String? qty;
  String? variant;
  int? productId;
  String? unitPrice;
  String? productName;
  String? categoryName;

  ProductsSold({
    this.qty,
    this.variant,
    this.productId,
    this.unitPrice,
    this.productName,
    this.categoryName,
  });

  ProductsSold.fromJson(Map<String, dynamic> json) {
    qty = json['qty'] ?? '0';
    variant = json['variant'] ?? '';
    productId = json['product_id'] ?? 0;
    unitPrice = json['unit_price'] ?? '0.0';
    productName = json['product_name'] ?? '';
    categoryName = json['category_name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['qty'] = this.qty;
    data['variant'] = this.variant;
    data['product_id'] = this.productId;
    data['unit_price'] = this.unitPrice;
    data['product_name'] = this.productName;
    data['category_name'] = this.categoryName;
    return data;
  }
}
