// database.dart
import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

// Enums for data types
enum Types {
  eventKey,
  matchKey,
  allianceColor,
  selectedStation,
  eventFile,
  matchFile,
  team
}
enum AutoType { ampPlacement, speaker, startPosition, autonRating, comments }

// HiveObject for Match Data
@HiveType(typeId: 0)
class MatchData extends HiveObject {
  @HiveField(0)
  String eventKey;

  @HiveField(1)
  String matchKey;

  @HiveField(2)
  String allianceColor;

  @HiveField(3)
  String selectedStation;

  @HiveField(4)
  AutoData autoData; // ... (Add fields for Teleop and Endgame data as needed)

  MatchData({
    required this.eventKey,
    required this.matchKey,
    required this.allianceColor,
    required this.selectedStation,
    required this.autoData,
    // ... other required fields
  });

  // Implement toJson() and fromJson() for JSON serialization
  Map<String, dynamic> toJson() =>
      {
        'eventKey': eventKey,
        'matchKey': matchKey,
        'allianceColor': allianceColor,
        'selectedStation': selectedStation,
        'autoData': autoData.toJson(),
        // ... (Serialize other fields)
      };

  factory MatchData.fromJson(Map<String, dynamic> json) =>
      MatchData(
        eventKey: json['eventKey'],
        matchKey: json['matchKey'],
        allianceColor: json['allianceColor'],
        selectedStation: json['selectedStation'],
        autoData: AutoData.fromJson(json['autoData']),
        // ... (Deserialize other fields)
      );
}

// HiveObject for Auto Data
@HiveType(typeId: 1)
class AutoData {
  @HiveField(0)
  int ampPlacement;

  @HiveField(1)
  int speaker;

  @HiveField(2)
  String startPosition;

  @HiveField(3)
  int autonRating;

  @HiveField(4)
  String comments;

  AutoData({
    required this.ampPlacement,
    required this.speaker,
    required this.startPosition,
    required this.autonRating,
    required this.comments,
  });

  // Implement toJson() and fromJson() for JSON serialization
  Map<String, dynamic> toJson() =>
      {
        'ampPlacement': ampPlacement,
        'speaker': speaker,
        'startPosition': startPosition,
        'autonRating': autonRating,
        'comments': comments,
      };

  factory AutoData.fromJson(Map<String, dynamic> json) =>
      AutoData(
        ampPlacement: json['ampPlacement'],
        speaker: json['speaker'],
        startPosition: json['startPosition'],
        autonRating: json['autonRating'],
        comments: json['comments'],
      );
}

// ... (Define HiveObject classes for Teleop and Endgame data similarly)

// Hive Initialization
Future<void> initializeHive() async {
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(MatchDataAdapter());
  Hive.registerAdapter(AutoDataAdapter());
  // ... (Register adapters for Teleop and Endgame data)

  // Open boxes
  await Hive.openBox<MatchData>('matchData');
  await Hive.openBox<String>('eventFiles');
}

// Function to save a match to a JSON file
Future<void> saveMatchToJson(MatchData match) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/${match.matchKey}.json');
  final jsonString = jsonEncode(match.toJson());
  await file.writeAsString(jsonString);

  // Store the file path
  var eventFilesBox = Hive.box<String>('eventFiles');
  await eventFilesBox.add(file.path);
}

// Function to load matches from JSON files
Future<List<MatchData>> loadMatches() async {
  var eventFilesBox = Hive.box<String>('eventFiles');
  List<MatchData> matches = [];

  for (var filePath in eventFilesBox.values) {
    final file = File(filePath);
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final jsonMap = jsonDecode(jsonString);
      matches.add(MatchData.fromJson(jsonMap));
    }
  }

  return matches;
}