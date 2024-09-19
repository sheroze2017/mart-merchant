import 'package:hive/hive.dart';

part 'hive.g.dart'; // This links the generated code

@HiveType(typeId: 0)
class Attendance extends HiveObject {
  @HiveField(0)
  String? date;

  @HiveField(1)
  String? checkInTime;

  @HiveField(2)
  String? checkOutTime;

  @HiveField(3)
  bool? status;

  Attendance({
    this.date,
    this.checkInTime = '',
    this.checkOutTime = '',
    this.status,
  });
}

@HiveType(typeId: 1)
class RecordModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int quantityGm;

  @HiveField(3)
  double pricePkr;

  @HiveField(4)
  int stock;

  @HiveField(5)
  int stockSold;

  RecordModel({
    required this.id,
    required this.name,
    required this.quantityGm,
    required this.pricePkr,
    required this.stock,
    required this.stockSold,
  });
}

@HiveType(typeId: 2)
class SalesRecordModel extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  List<RecordModel> productsSold;

  SalesRecordModel({
    required this.date,
    required this.productsSold,
  });
}
