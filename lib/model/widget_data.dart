import 'package:hive/hive.dart';

part 'widget_data.g.dart';

@HiveType(typeId: 0)
class WidgetData extends HiveObject {
  @HiveField(0)
  String type;

  @HiveField(1)
  Map<String, dynamic> properties;

  WidgetData(this.type, this.properties);
}
