

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'Components/TeamInfo.dart';


class AutonBuilder extends StatefulWidget {
  const AutonBuilder({Key? key}) : super(key: key);

  @override
  AutonState createState() => AutonState();

}

class AutonState extends State<AutonBuilder> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTeamInfo(201, 1, 'Red'),
      ],
    );
  }
}