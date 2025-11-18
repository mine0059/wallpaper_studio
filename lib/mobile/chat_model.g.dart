// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChartModelAdapter extends TypeAdapter<ChartModel> {
  @override
  final int typeId = 3;

  @override
  ChartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartModel(
      time: fields[0] as int?,
      open: fields[1] as double?,
      high: fields[2] as double?,
      low: fields[3] as double?,
      close: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ChartModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.open)
      ..writeByte(2)
      ..write(obj.high)
      ..writeByte(3)
      ..write(obj.low)
      ..writeByte(4)
      ..write(obj.close);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
