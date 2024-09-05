class Brand {
  final int brandId;
  final String brandName;

  Brand({
    required this.brandId,
    required this.brandName,
  });
}

class Location {
  final String placeId;
  final String placeName;
  final double latitude;
  final double longitude;

  Location({
    required this.placeId,
    required this.placeName,
    required this.latitude,
    required this.longitude,
  });
}

class Employee {
  final int userId;
  final String name;
  final String email;
  final String phone;
  final int age;
  final String role;
  final String gender;
  final Location location;
  final String imageUrl;

  Employee({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.role,
    required this.gender,
    required this.location,
    required this.imageUrl,
  });
}
