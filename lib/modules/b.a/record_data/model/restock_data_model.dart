class RestockDataModel {
  int? code;
  bool? success;
  List<IndividualRestockData>? data;
  String? message;

  RestockDataModel({this.code, this.success, this.data, this.message});

  RestockDataModel.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    success = json['sucess'] ?? false;
    if (json['data'] != null && (json['data'] as List).isNotEmpty) {
      data = <IndividualRestockData>[];
      json['data'].forEach((v) {
        data!.add(IndividualRestockData.fromJson(v));
      });
    } else {
      data = []; // Default empty list if null or empty
    }
    message = json['message'] ?? 'No message available';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code ?? 0;
    data['sucess'] = this.success ?? false;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message ?? 'No message available';
    return data;
  }
}

class IndividualRestockData {
  int? restockId;
  String? createdAt;
  BADetails? bADetails;
  MartDetails? martDetails;
  ProductDetails? productDetails;

  IndividualRestockData({
    this.restockId,
    this.createdAt,
    this.bADetails,
    this.martDetails,
    this.productDetails,
  });

  IndividualRestockData.fromJson(Map<String, dynamic> json) {
    restockId = json['restock_id'] ?? 0;
    createdAt = json['created_at'] ?? 'N/A';
    bADetails = json['BA_Details'] != null
        ? BADetails.fromJson(json['BA_Details'])
        : BADetails(); // Use empty BADetails if null
    martDetails = json['mart_details'] != null
        ? MartDetails.fromJson(json['mart_details'])
        : MartDetails(); // Use empty MartDetails if null
    productDetails = json['product_details'] != null
        ? ProductDetails.fromJson(json['product_details'])
        : ProductDetails(); // Use empty ProductDetails if null
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restock_id'] = this.restockId ?? 0;
    data['created_at'] = this.createdAt ?? 'N/A';
    if (this.bADetails != null) {
      data['BA_Details'] = this.bADetails!.toJson();
    }
    if (this.martDetails != null) {
      data['mart_details'] = this.martDetails!.toJson();
    }
    if (this.productDetails != null) {
      data['product_details'] = this.productDetails!.toJson();
    }
    return data;
  }
}

class BADetails {
  String? name;
  String? email;
  String? phone;

  BADetails({
    this.name,
    this.email,
    this.phone,
  });

  BADetails.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? 'N/A';
    email = json['email'] ?? 'N/A';
    phone = json['phone'] ?? 'N/A';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = this.name ?? 'N/A';
    data['email'] = this.email ?? 'N/A';
    data['phone'] = this.phone ?? 'N/A';
    return data;
  }
}

class MartDetails {
  String? location;
  String? martName;

  MartDetails({
    this.location,
    this.martName,
  });

  MartDetails.fromJson(Map<String, dynamic> json) {
    location = json['location'] ?? 'N/A';
    martName = json['mart_name'] ?? 'N/A';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location'] = this.location ?? 'N/A';
    data['mart_name'] = this.martName ?? 'N/A';
    return data;
  }
}

class ProductDetails {
  String? price;
  String? variant;
  String? productName;

  ProductDetails({
    this.price,
    this.variant,
    this.productName,
  });

  ProductDetails.fromJson(Map<String, dynamic> json) {
    price = json['price'] ?? '0';
    variant = json['variant'] ?? 'N/A';
    productName = json['product_name'] ?? 'N/A';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = this.price ?? '0';
    data['variant'] = this.variant ?? 'N/A';
    data['product_name'] = this.productName ?? 'N/A';
    return data;
  }
}
