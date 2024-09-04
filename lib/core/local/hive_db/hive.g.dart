// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceAdapter extends TypeAdapter<Attendance> {
  @override
  final int typeId = 0;

  @override
  Attendance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Attendance(
      date: fields[0] as String,
      checkInTime: fields[1] as String,
      checkOutTime: fields[2] as String,
      status: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Attendance obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.checkInTime)
      ..writeByte(2)
      ..write(obj.checkOutTime)
      ..writeByte(3)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecordModelAdapter extends TypeAdapter<RecordModel> {
  @override
  final int typeId = 1;

  @override
  RecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecordModel(
      id: fields[0] as int,
      name: fields[1] as String,
      quantityGm: fields[2] as int,
      pricePkr: fields[3] as double,
      stock: fields[4] as int,
      stockSold: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RecordModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.quantityGm)
      ..writeByte(3)
      ..write(obj.pricePkr)
      ..writeByte(4)
      ..write(obj.stock)
      ..writeByte(5)
      ..write(obj.stockSold);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SalesRecordModelAdapter extends TypeAdapter<SalesRecordModel> {
  @override
  final int typeId = 2;

  @override
  SalesRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesRecordModel(
      date: fields[0] as DateTime,
      productsSold: (fields[1] as List).cast<RecordModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, SalesRecordModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.productsSold);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
