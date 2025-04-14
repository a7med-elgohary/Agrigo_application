// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmarked_plant.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookmarkedPlantAdapter extends TypeAdapter<BookmarkedPlant> {
  @override
  final int typeId = 2;

  @override
  BookmarkedPlant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookmarkedPlant(
      id: fields[0] as String,
      name: fields[1] as String,
      family: fields[2] as String,
      image: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookmarkedPlant obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.family)
      ..writeByte(3)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkedPlantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
} 