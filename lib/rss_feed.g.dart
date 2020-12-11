// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rss_feed.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeedAdapter extends TypeAdapter<Feed> {
  @override
  final int typeId = 1;

  @override
  Feed read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Feed(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
    )..read = fields[5] as bool;
  }

  @override
  void write(BinaryWriter writer, Feed obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.sourceUrl)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.lastPubDate)
      ..writeByte(5)
      ..write(obj.read);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
