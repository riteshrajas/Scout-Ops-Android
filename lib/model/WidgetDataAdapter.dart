import 'package:hive/hive.dart';
import 'widget_data.dart';

class WidgetDataAdapter extends TypeAdapter<WidgetData> {
  @override
  final int typeId = 0;

  @override
  WidgetData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WidgetData(
      fields[0] as String,
      (fields[1] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, WidgetData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.properties);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
