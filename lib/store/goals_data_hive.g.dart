// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_data_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalsDataAdapter extends TypeAdapter<GoalsData> {
  @override
  final int typeId = 0;

  @override
  GoalsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalsData(
      goalId: fields[0] as int,
      goalName: fields[1] as String,
      goalSelected: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GoalsData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.goalId)
      ..writeByte(1)
      ..write(obj.goalName)
      ..writeByte(2)
      ..write(obj.goalSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
