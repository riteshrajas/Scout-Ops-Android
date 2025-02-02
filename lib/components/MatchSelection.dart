import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class MatchSelection extends StatefulWidget {
  final Function(String?) onAllianceSelected;
  final Function(String?) onPositionSelected;
  final String initAlliance;
  final String initPosition;

  const MatchSelection({super.key, required this.onAllianceSelected, required this.onPositionSelected, required this.initAlliance, required this.initPosition});

  @override
  _MatchSelectionState createState() => _MatchSelectionState();
}

class _MatchSelectionState extends State<MatchSelection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 10, right: 10),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            spacing: 8,
            children: ['Red', 'Blue'].map((String value) {
              return Expanded(
                child: ChoiceChip(
                  label: Center(
                    child: Text(
                      value,
                      style: GoogleFonts.museoModerno(fontSize: 25),
                    ),
                  ),
                  selectedColor: value == "Red"
                      ? const Color.fromARGB(255, 230, 75, 75)
                      : const Color.fromARGB(147, 0, 122, 248),
                  selected: widget.initAlliance == value ? true : false,
                  side: const BorderSide(color: Colors.black),
                  onSelected: (bool selected) {
                    widget.onAllianceSelected(selected ? value : "");
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Row(
            spacing: 8,
            children: ['1', '2', '3'].map((String value) {
              return Expanded(
                child: ChoiceChip(
                  label: Center(
                    child: Text(
                        ((Hive.box('userData').get('alliance') == "Red") ? "R" : "B") + value,
                      style: GoogleFonts.museoModerno(fontSize: 25),
                    ),
                  ),
                  selectedColor: Hive.box('userData').get('alliance') == "Red"
                      ? const Color.fromARGB(255, 230, 75, 75)
                      : const Color.fromARGB(147, 0, 122, 248),
                  selected: widget.initPosition == value,
                  side: const BorderSide(color: Colors.black),
                  onSelected: (bool selected) {
                    widget.onPositionSelected(selected ? value : "");
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}