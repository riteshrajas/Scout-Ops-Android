import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scouting_app/components/CheckBox.dart';
import 'package:scouting_app/components/Map.dart';
import 'package:scouting_app/components/stopwatch.dart';
import 'package:slider_button/slider_button.dart';

import '../../components/Chips.dart';
import '../../components/CommentBox.dart';
import '../../components/DataBase.dart';
import '../../components/QrGenerator.dart';
import '../../components/RatingsBox.dart';
import '../../components/ratings.dart';
import '../match.dart';

class EndGame extends StatefulWidget {
  const EndGame({super.key});

  @override
  _EndGameState createState() => _EndGameState();
}

class _EndGameState extends State<EndGame> {
  final LocalDataBase dataMaster = LocalDataBase();
  late Offset endLocation;

  late int trapNotePosition;
  late String allianceColor;
  late bool harmony;
  late bool immobile;
  late bool climbed;
  late bool spotlight;
  late double stopWatchValue;
  late double robotSpeed;
  late double autonRating;
  late bool tippy;
  late bool notesDropped;

  final Stopwatch _stopwatch = Stopwatch();
  late Timer stopWatchTime;

  bool isbelowAverage = false;
  bool isAverage = false;
  bool isGood = false;
  bool isExcellent = false;
  bool notEffective = false;
  bool average = false;
  bool veryEffective = false;

  @override
  void initState() {
    super.initState();
    stopWatchValue = LocalDataBase.getData(EndgameType.climb_time) ?? 0;
    robotSpeed = LocalDataBase.getData(EndgameType.robot_speed) ?? 0;
    endLocation =
        LocalDataBase.getData(EndgameType.endLocation) ?? Offset(10, 10);
    climbed = LocalDataBase.getData(EndgameType.climbed) ?? false;
    harmony = LocalDataBase.getData(EndgameType.harmony) ?? false;
    allianceColor = LocalDataBase.getData(Types.allianceColor) ?? "Null";
    immobile = LocalDataBase.getData(EndgameType.immobile) ?? false;
    spotlight = LocalDataBase.getData(EndgameType.spotlight) ?? false;
    tippy = LocalDataBase.getData(EndgameType.tippy) ?? false;
    notesDropped = LocalDataBase.getData(EndgameType.notes_droped) ?? false;

    stopWatchTime = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    stopWatchTime.cancel();
    super.dispose();
  }

  void UpdateData() {
    LocalDataBase.putData(EndgameType.endLocation, endLocation);
    LocalDataBase.putData(EndgameType.climbed, climbed);
    LocalDataBase.putData(EndgameType.harmony, harmony);
    LocalDataBase.putData(EndgameType.immobile, immobile);
    LocalDataBase.putData(EndgameType.spotlight, spotlight);
    LocalDataBase.putData(EndgameType.driver_rating, getDriverRating());
    LocalDataBase.putData(EndgameType.robot_speed, robotSpeed);
    LocalDataBase.putData(
        EndgameType.climb_time, stopWatchValue); // Save the stopWatchValue
    LocalDataBase.putData(EndgameType.tippy, tippy);
    LocalDataBase.putData(EndgameType.notes_droped, notesDropped);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildMap(
            context,
            endLocation,
            const Size(35, 35),
            allianceColor,
            onTap: (TapUpDetails details) {
              _updatePosition(details);
            },
            image: Image.asset('assets/Areana.png'),
          ),
          StopwatchWidget(
              time: stopWatchValue,
              onStopped: (double value) {
                setState(() {
                  stopWatchValue = value;
                  UpdateData();
                  print("Stopwatch Value: $stopWatchValue");
                });
              }),
          Container(
            child: buildComments(
                "Match Knowledge",
                [
                  buildComments(
                    "Defense Rating",
                    [
                      buildChips([
                        "Below Average",
                        "Average",
                        "Good",
                        "Excellent",
                      ], [
                        [Colors.red, Colors.white],
                        [Colors.green, Colors.white],
                        [Colors.blue, Colors.white],
                        [Colors.deepOrange, Colors.white]
                      ], [
                        isbelowAverage,
                        isAverage,
                        isGood,
                        isExcellent,
                      ], onTapList: [
                        (String label) {
                          setState(() {
                            isbelowAverage = !isbelowAverage;
                            isAverage = isAverage;
                            isGood = false;
                            isExcellent = false;
                          });
                          UpdateData();
                        },
                        (String label) {
                          setState(() {
                            isbelowAverage = false;
                            isAverage = !isAverage;
                            isGood = isGood;
                            isExcellent = false;
                          });
                          UpdateData();
                        },
                        (String label) {
                          setState(() {
                            isbelowAverage = false;
                            isAverage = false;
                            isGood = !isGood;
                            isExcellent = false;
                          });
                          UpdateData();
                        },
                        (String label) {
                          setState(() {
                            isbelowAverage = false;
                            isAverage = false;
                            isGood = false;
                            isExcellent = !isExcellent;
                          });
                          UpdateData();
                        },
                      ]),
                    ],
                    const Icon(Icons.comment_bank),
                  ),
                  buildComments(
                    "Driver Skill",
                    [
                      buildChips([
                        "Not Effective",
                        "Average",
                        "Very Effective",
                      ], [
                        [Colors.red, Colors.white],
                        [Colors.green, Colors.white],
                        [Colors.blue, Colors.white],
                      ], [
                        notEffective,
                        average,
                        veryEffective,
                      ], onTapList: [
                        (String label) {
                          setState(() {
                            notEffective = !notEffective;
                            average = average;
                            veryEffective = false;
                          });
                          UpdateData();
                        },
                        (String label) {
                          setState(() {
                            notEffective = false;
                            average = !average;
                            veryEffective = veryEffective;
                          });
                          UpdateData();
                        },
                        (String label) {
                          setState(() {
                            notEffective = false;
                            average = false;
                            veryEffective = !veryEffective;
                          });
                          UpdateData();
                        },
                      ]),
                    ],
                    const Icon(Icons.comment_bank),
                  ),
                  buildRatings([
                    buildRating("Robot Speed", Icons.speed,
                        robotSpeed.toDouble(), 5, Colors.yellow.shade600,
                        onRatingUpdate: (double rating) {
                      setState(() {
                        robotSpeed = rating.toDouble();
                        UpdateData();
                      });
                    }, icon2: Icons.directions_run_outlined),
                  ]),
                ],
                const Icon(IconData(0xe3c9, fontFamily: 'MaterialIcons'))),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              buildCheckBox("Climbed?", climbed, (bool value) {
                setState(() {
                  climbed = value;
                });
                UpdateData();
              }, IconOveride: true),
              buildCheckBox("Immobilized?", immobile, (bool value) {
                setState(() {
                  immobile = value;
                });
                UpdateData();
              }, IconOveride: true),
            ]),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              buildCheckBox("Spotlight?", spotlight, (bool value) {
                setState(() {
                  spotlight = value;
                });
                UpdateData();
              }, IconOveride: true),
              buildCheckBox("Harmony?", harmony, (bool value) {
                setState(() {
                  harmony = value;
                });
                UpdateData();
              }, IconOveride: true),
            ]),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              buildCheckBox("Tippy?", tippy, (bool value) {
                setState(() {
                  tippy = value;
                });
                UpdateData();
              }, IconOveride: true),
              buildCheckBox("> 2 Notes Dropped?", notesDropped, (bool value) {
                setState(() {
                  notesDropped = value;
                });
                UpdateData();
              }, IconOveride: true),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: MediaQuery.of(context).size.width - 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SliderButton(
                  buttonColor: Colors.yellow,
                  backgroundColor: Colors.white,
                  highlightedColor: Colors.green,
                  dismissThresholds: 0.97,
                  vibrationFlag: true,
                  width: MediaQuery.of(context).size.width - 16,
                  action: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Qrgenerator()));
                    return null;
                  },
                  label: const Text("Slide to Complete Event",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                      textAlign: TextAlign.start),
                  icon: const Icon(Icons.send_outlined,
                      size: 30, color: Colors.black),
                )),
          )
        ],
      ),
    );
  }

  void _updatePosition(TapUpDetails details) {
    setState(() {
      endLocation = details.localPosition;
      LocalDataBase.putData(AutoType.StartPosition, endLocation);
    });
    UpdateData();
  }

  // double? _parseSize(String? size) {
  //   return size != null ? double.tryParse(size) : null;
  // }

  Color _parseColor(String? color) {
    return color != null ? Color(int.parse(color)) : Colors.transparent;
  }

  // MainAxisAlignment _parseMainAxisAlignment(String? alignment) {
  //   switch (alignment) {
  //     case 'start':
  //       return MainAxisAlignment.start;
  //     case 'center':
  //       return MainAxisAlignment.center;
  //     case 'end':
  //       return MainAxisAlignment.end;
  //     default:
  //       return MainAxisAlignment.start;
  //   }
  // }
  //
  // Offset _parseOffset(String? offsetString) {
  //   if (offsetString == null) return Offset.zero;
  //   final parts = offsetString.split(',');
  //   return Offset(double.parse(parts[0]), double.parse(parts[1]));
  // }
  //
  // IconData _parseIconData(String? iconData) {
  //   return Icons.help;
  // }
  //
  // List<BoxShadow> _parseBoxShadows(List<dynamic>? boxShadows) {
  //   if (boxShadows == null) return [];
  //   return boxShadows.map((shadow) {
  //     return BoxShadow(
  //       color: _parseColor(shadow['color']),
  //       spreadRadius: shadow['spreadRadius']?.toDouble() ?? 0,
  //       blurRadius: shadow['blurRadius']?.toDouble() ?? 0,
  //       offset: Offset(
  //         shadow['offset']['x']?.toDouble() ?? 0,
  //         shadow['offset']['y']?.toDouble() ?? 0,
  //       ),
  //     );
  //   }).toList();
  // }

  getDriverRating() {
    if (isbelowAverage) {
      return 1;
    } else if (isAverage) {
      return 2;
    } else if (isGood) {
      return 3;
    } else if (isExcellent) {
      return 4;
    } else {
      return 0;
    }
  }
}

// Define your MapWidget separately if not defined
class MapWidget extends StatelessWidget {
  final Offset endLocation;
  final Size size;
  final Color allianceColor;
  final ImageProvider image;
  final Function(TapUpDetails) onTap;

  const MapWidget({
    Key? key,
    required this.endLocation,
    required this.size,
    required this.allianceColor,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(); // Placeholder
  }
}