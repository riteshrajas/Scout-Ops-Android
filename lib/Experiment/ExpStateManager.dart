import 'package:hive/hive.dart';

class ExpStateManager {
  final Box box = Hive.box('experiments');

  Future<Map<String, bool>> loadAllPluginStates(List<String> pluginKeys) async {
    Map<String, bool> states = {};
    for (var key in pluginKeys) {
      states[key] = box.get(key, defaultValue: false);
    }
    return states;
  }

  Future<void> saveAllPluginStates(Map<String, bool> states) async {
    for (var entry in states.entries) {
      await box.put(entry.key, entry.value);
    }
  }
}
