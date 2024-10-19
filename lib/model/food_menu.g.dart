// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_menu.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodMenuAdapter extends TypeAdapter<FoodMenu> {
  @override
  final int typeId = 1;

  @override
  FoodMenu read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodMenu(
      id: fields[0] as String?,
      img: fields[1] as String?,
      name: fields[2] as String?,
      dsc: fields[3] as String?,
      price: fields[4] as double?,
      rate: fields[5] as int?,
      country: fields[6] as String?,
      quantity: fields[7] as int?,
      isPrepared: fields[8] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, FoodMenu obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.img)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.dsc)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.rate)
      ..writeByte(6)
      ..write(obj.country)
      ..writeByte(7)
      ..write(obj.quantity)
      ..writeByte(8)
      ..write(obj.isPrepared);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodMenuAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
