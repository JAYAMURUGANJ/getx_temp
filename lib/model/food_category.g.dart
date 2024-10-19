// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodCategoryAdapter extends TypeAdapter<FoodCategory> {
  @override
  final int typeId = 4;

  @override
  FoodCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodCategory(
      name: fields[0] as String,
      imagePath: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FoodCategory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
