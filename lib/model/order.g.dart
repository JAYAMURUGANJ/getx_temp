// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 5;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      orderTypeId: fields[0] as int,
      phoneNo: fields[1] as String?,
      tableNo: fields[2] as int,
      startDateTime: fields[3] as DateTime,
      endDateTime: fields[4] as DateTime?,
      orderStatus: fields[5] as int?,
      payementStatus: fields[6] as int?,
      customerName: fields[7] as String?,
      orderTrackId: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.orderTypeId)
      ..writeByte(1)
      ..write(obj.phoneNo)
      ..writeByte(2)
      ..write(obj.tableNo)
      ..writeByte(3)
      ..write(obj.startDateTime)
      ..writeByte(4)
      ..write(obj.endDateTime)
      ..writeByte(5)
      ..write(obj.orderStatus)
      ..writeByte(6)
      ..write(obj.payementStatus)
      ..writeByte(7)
      ..write(obj.customerName)
      ..writeByte(8)
      ..write(obj.orderTrackId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
