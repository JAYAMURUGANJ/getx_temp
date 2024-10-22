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
      orderStatusId: fields[5] as int,
      payementStatusId: fields[6] as int,
      customerName: fields[7] as String?,
      orderTrackId: fields[8] as String?,
      paymentTypeId: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.orderStatusId)
      ..writeByte(6)
      ..write(obj.payementStatusId)
      ..writeByte(7)
      ..write(obj.customerName)
      ..writeByte(8)
      ..write(obj.orderTrackId)
      ..writeByte(9)
      ..write(obj.paymentTypeId);
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
