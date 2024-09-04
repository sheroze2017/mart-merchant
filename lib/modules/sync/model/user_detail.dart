class UserDetails {
  UserInfo? userInfo;
  List<ULocations>? locations;
  List<Products>? products;

  UserDetails({this.userInfo, this.locations, this.products});

  UserDetails.fromJson(Map<String, dynamic> json) {
    userInfo = json['userInfo'] != null
        ? new UserInfo.fromJson(json['userInfo'])
        : null;
    if (json['locations'] != null) {
      locations = <ULocations>[];
      json['locations'].forEach((v) {
        locations!.add(new ULocations.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userInfo != null) {
      data['userInfo'] = this.userInfo!.toJson();
    }
    if (this.locations != null) {
      data['locations'] = this.locations!.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserInfo {
  String? username;
  String? userRole;

  UserInfo({this.username, this.userRole});

  UserInfo.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    userRole = json['userRole'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['userRole'] = this.userRole;
    return data;
  }
}

class ULocations {
  String? locationName;
  double? latitude;
  double? longitude;
  List<Brands>? brands;

  ULocations({this.locationName, this.latitude, this.longitude, this.brands});

  ULocations.fromJson(Map<String, dynamic> json) {
    locationName = json['locationName'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['brands'] != null) {
      brands = <Brands>[];
      json['brands'].forEach((v) {
        brands!.add(new Brands.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationName'] = this.locationName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    if (this.brands != null) {
      data['brands'] = this.brands!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Brands {
  int? brandId;
  String? brandName;

  Brands({this.brandId, this.brandName});

  Brands.fromJson(Map<String, dynamic> json) {
    brandId = json['brandId'];
    brandName = json['brandName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandId'] = this.brandId;
    data['brandName'] = this.brandName;
    return data;
  }
}

class Products {
  String? productName;
  double? price;
  int? brandId;

  Products({this.productName, this.price, this.brandId});

  Products.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    price = json['price'];
    brandId = json['brandId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productName'] = this.productName;
    data['price'] = this.price;
    data['brandId'] = this.brandId;
    return data;
  }
}
