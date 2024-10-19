// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payement_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentTypeAdapter extends TypeAdapter<PaymentType> {
  @override
  final int typeId = 2;

  @override
  PaymentType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentType(
      id: fields[0] as int?,
      name: fields[1] as String?,
      ico: fields[2] as IconData?,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentType obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.ico);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
