import 'package:flutter/material.dart';

class Match extends StatefulWidget {
  final String eventKey;
  final String matchKey;
  final String? allianceColor;
  final String? station;
  final Map<String, dynamic> MatchData;

  const Match(
      {super.key,
      required this.eventKey,
      required this.matchKey,
      required this.allianceColor,
      required this.station,
      required this.MatchData});

  @override
  MatchState createState() => MatchState();
}

class MatchState extends State<Match> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Page'),
        actions: <Widget>[
          Text("${widget.station}",
              style: const TextStyle(
                fontSize: 20,
              )),
          const SizedBox(width: 10),
        ],
      ),
      body: match(context, _selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Auto',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Teleop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'End Game',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            widget.allianceColor == "Red" ? Colors.red : Colors.blue,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  match(BuildContext context, int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return Center(child: auto(context));
      case 1:
        return Row(children: teleop(context));
      case 2:
        return Row(children: endGame(context));
    }
  }

  Widget auto(BuildContext context) {
    switch (widget.allianceColor) {
      case "Red":
        return Column(
            children: autoBuilder(context, widget.allianceColor,
                widget.MatchData, widget.station));
      case "Blue":
        return Column(
            children: autoBuilder(context, widget.allianceColor,
                widget.MatchData, widget.station));
      default:
        return const Text("Error: Invalid Alliance Color");
    }
  }

  List<Widget> teleop(BuildContext context) {
    return [];
  }

  List<Widget> endGame(BuildContext context) {
    return [];
  }

  List<Widget> autoBuilder(BuildContext context, String? alliancecolor,
      Map<String, dynamic> matchData, String? station) {
    return [
      Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(children: [
            Text(
                "Assigned Team: ${(matchData["alliances"][alliancecolor?.toLowerCase()]["team_keys"][int.parse(station![1]) - 1]).substring(3)}",
                style: const TextStyle(fontSize: 30, color: Colors.black45)),
          ]),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(children: [
            const Text("Starting Position",
                style: TextStyle(fontSize: 30, color: Colors.black45)),
            const SizedBox(height: 10),
            Image(
                image: AssetImage(
                    'assets/${alliancecolor}Alliance_StartPosition.png')),
            const SizedBox(height: 10),
          ]),
        ),
      )
    ];
  }
}
