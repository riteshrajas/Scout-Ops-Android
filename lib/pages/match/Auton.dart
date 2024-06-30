import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:scouting_app/pages/components/DataBase.dart';
import '../match.dart';

class Auton extends StatefulWidget {
  const Auton({super.key});

  @override
  AutonState createState() => AutonState();
}

class AutonState extends State<Auton> {
  final LocalDataBase dataMaster = LocalDataBase();
  Offset? _circlePosition;
  int ampPlacementValue = 0;
  int speakerValue = 0;
  int autonRating = 0;

  late String assignedTeam;
  late String assignedStation;
  late String matchKey;
  late String allianceColor;

  // Match Variables
  @override
  void initState() {
    super.initState();
    assignedTeam = LocalDataBase.getData(Types.team) ?? "Null";
    assignedStation = LocalDataBase.getData(Types.selectedStation) ?? "Null";
    autonRating = LocalDataBase.getData(AutoType.AutonRating) ?? 0;
  }

  void UpdateData( ampPlacementValue, speakerValue, _circlePosition, autonRating) {
    LocalDataBase.putData(AutoType.AmpPlacement, ampPlacementValue);
    LocalDataBase.putData(AutoType.Speaker, speakerValue);
    LocalDataBase.putData(AutoType.StartPosition, _circlePosition);
    LocalDataBase.putData(AutoType.AutonRating, autonRating);
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      assignedTeam = LocalDataBase.getData(Types.team) ?? "Null";
      assignedStation = LocalDataBase.getData(Types.selectedStation) ?? "Null";
      matchKey = LocalDataBase.getData(Types.matchKey) ?? "Null";
      allianceColor = LocalDataBase.getData(Types.allianceColor) ?? "Null";
    });
    return Container(child: _buildAuto(context));
  }

  Widget _buildAuto(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [_buildTeamInfo(), _buildBotField(), _buildActions(), _buildComments()],
      ),
    );
  }
  Widget _buildTeamInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.category,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignedTeam,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$allianceColor Alliance, Station $assignedStation',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'START',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildBotField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Stack(
            children: [
              GestureDetector(
                onTapUp: _updatePosition,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0), // Add border radius here
                  child: Image.asset(
                    'assets/${LocalDataBase.getData(Types.allianceColor)}Alliance_StartPosition.png',
                  ),
                ),
              ),
              if (_circlePosition != null)
                Positioned(
                  left: _circlePosition!.dx - 10, // Center the circle
                  top: _circlePosition!.dy - 10, // Center the circle
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0), // Add border radius here
                      child: Image.asset(
                        'assets/Swerve.png',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

      )
    );
  }
  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
      decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome),
              const SizedBox(width: 16),
              const Text(
                'Amp Placement',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        ampPlacementValue = ampPlacementValue - 1;
                        UpdateData(ampPlacementValue, speakerValue, _circlePosition, autonRating);
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    '$ampPlacementValue',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        ampPlacementValue = ampPlacementValue + 1;
                        UpdateData(ampPlacementValue, speakerValue, _circlePosition, autonRating);
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.speaker),
              const SizedBox(width: 16),
              const Text(
                'Speaker',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        speakerValue = speakerValue - 1;
                        UpdateData(ampPlacementValue, speakerValue, _circlePosition, autonRating );
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    '$speakerValue',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        speakerValue = speakerValue + 1;
                        UpdateData(ampPlacementValue, speakerValue, _circlePosition, autonRating);
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    ),
    );
  }
  Widget _buildComments() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.sports_soccer_rounded),
                  SizedBox(width: 16),
                  Text(
                    'Auton Rating',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              const SizedBox(height: 8),
              Center(
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  glow: false,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ),
              const SizedBox(height: 22),
              const Row(
                children: [
                  Icon(Icons.comment),
                  SizedBox(width: 16),
                  Text(
                    'Your Comments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Chip(
                    label: Text('Chip 1'),
                    backgroundColor: Colors.red,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Chip(
                    label: Text('Chip 2'),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Chip(
                    label: Text('Chip 3'),
                    backgroundColor: Colors.blue,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _updatePosition(TapUpDetails details) {
    setState(() {
      _circlePosition = details.localPosition;
      LocalDataBase.putData(AutoType.StartPosition, _circlePosition);
    });
  }
}

enum AutoType { AmpPlacement, Speaker, StartPosition, AutonRating, Comments }