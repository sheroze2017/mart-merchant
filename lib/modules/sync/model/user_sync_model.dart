class PersonalInfo {
  String name;
  String userRole;
  int age;

  PersonalInfo({
    this.name = '',
    this.userRole = '',
    this.age = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'userRole': userRole,
      'age': age,
    };
  }

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'],
      userRole: json['userRole'],
      age: json['age'],
    );
  }
}

class AttendanceAll {
  String? date;
  String? checkInTime;
  String? checkOutTime;
  bool? status;

  AttendanceAll({this.date, this.checkInTime, this.checkOutTime, this.status});

  AttendanceAll.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    checkInTime = json['checkInTime'];
    checkOutTime = json['checkOutTime'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'data': date,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'status': status,
    };
  }
}

class Location {
  final String locationName;
  final double latitude;
  final double longitude;
  final String brandName;
  final int count;

  Location({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.brandName,
    required this.count,
  });

  Map<String, dynamic> toJson() {
    return {
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'brandName': brandName,
      'count': count,
    };
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationName: json['locationName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      brandName: json['brandName'],
      count: json['count'],
    );
  }
}

class Product {
  final String productName;
  final int quantity;
  final double price;

  Product({
    required this.productName,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['productName'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}

class SaleDetail {
  final String locationName;
  final String brandName;
  final List<Product> products;

  SaleDetail({
    required this.locationName,
    required this.brandName,
    required this.products,
  });

  Map<String, dynamic> toJson() {
    return {
      'locationName': locationName,
      'brandName': brandName,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }

  factory SaleDetail.fromJson(Map<String, dynamic> json) {
    return SaleDetail(
      locationName: json['locationName'],
      brandName: json['brandName'],
      products: (json['products'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }
}

class Sales {
  final DateTime date;
  final List<SaleDetail> saleDetails;

  Sales({
    required this.date,
    required this.saleDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'saleDetails': saleDetails.map((detail) => detail.toJson()).toList(),
    };
  }

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      date: DateTime.parse(json['date']),
      saleDetails: (json['saleDetails'] as List)
          .map((detail) => SaleDetail.fromJson(detail))
          .toList(),
    );
  }
}

class AppData {
  PersonalInfo? personalInfo;
  List<AttendanceAll> attendance;
  List<Location> locations;
  List<Product> products;
  List<Sales> sales;

  AppData({
    this.personalInfo = null,
    this.attendance = const [],
    this.locations = const [],
    this.products = const [],
    this.sales = const [],
  });

  factory AppData.fromJson(Map<String, dynamic> json) {
    var attendanceFromJson = json['attendance'] as List;
    List<AttendanceAll> attendanceList =
        attendanceFromJson.map((i) => AttendanceAll.fromJson(i)).toList();

    var locationsFromJson = json['locations'] as List;
    List<Location> locationList =
        locationsFromJson.map((i) => Location.fromJson(i)).toList();

    var productsFromJson = json['products'] as List;
    List<Product> productList =
        productsFromJson.map((i) => Product.fromJson(i)).toList();

    var salesFromJson = json['sales'] as List;
    List<Sales> salesList =
        salesFromJson.map((i) => Sales.fromJson(i)).toList();

    return AppData(
      personalInfo: PersonalInfo.fromJson(json['personalInfo']),
      attendance: attendanceList,
      locations: locationList,
      products: productList,
      sales: salesList,
    );
  }

  Map<String, dynamic> toJson() => {
        'personalInfo': personalInfo!.toJson(),
        'attendance': attendance.map((a) => a.toJson()).toList(),
        'locations': locations.map((l) => l.toJson()).toList(),
        'products': products.map((p) => p.toJson()).toList(),
        'sales': sales.map((s) => s!.toJson()).toList(),
      };
}
