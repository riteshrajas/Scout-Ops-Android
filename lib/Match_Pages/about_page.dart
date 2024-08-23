import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scouting_app/components/Chips.dart';
import 'package:scouting_app/components/plugin-tile.dart';

import '../components/nav.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          title: const Text('About Us'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            ExpandableTile(
              title: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.red, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  'Scout-Ops',
                  style: GoogleFonts.chivoMono(
                    fontSize: 30,
                    fontWeight: FontWeight.w100,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap_Widget: () {},
              icon_Widget: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.redAccent, Colors.blue],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: const Icon(Icons.info, color: Colors.white, size: 35),
              ),
              expanded_Widget: true,
              Expanded_Widget: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "ScoutOps is an FRC Scouting app designed to streamline the tracking and analysis of match performance data. While it’s customized for the needs of our team, FEDS 201, its versatility makes it a valuable tool for any team.",
                  style: GoogleFonts.chivoMono(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ExpandableTile(
              title: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.purple, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  'Team & Dedication',
                  style: GoogleFonts.chivoMono(
                    fontSize: 30,
                    fontWeight: FontWeight.w100,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap_Widget: () {},
              icon_Widget: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.purpleAccent, Colors.orangeAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: const Icon(Icons.group, color: Colors.white, size: 35),
              ),
              expanded_Widget: true,
              Expanded_Widget: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "ScoutOps is dedicated to the hardworking members of FEDS 201, the Falcon Engineering and Design Solutions team from Rochester High School. This app reflects our commitment to excellence in robotics.",
                  style: GoogleFonts.chivoMono(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ExpandableTile(
              title: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.teal, Colors.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  'Open Source Tools',
                  style: GoogleFonts.chivoMono(
                    fontSize: 30,
                    fontWeight: FontWeight.w100,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap_Widget: () {},
              icon_Widget: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.tealAccent, Colors.lightGreen],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: const Icon(Icons.credit_card,
                    color: Colors.white, size: 35),
              ),
              expanded_Widget: true,
              Expanded_Widget: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                    Text(
                      "We extend our gratitude to the open-source community and projects that made ScoutOps possible",
                      style: GoogleFonts.chivoMono(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8.0, // Horizontal space between chips.
                      runSpacing: 4.0, // Vertical space between lines of chips.
                      children: [
                        buildChip(
                            "Flutter", [Colors.blue, Colors.blueAccent], false),
                        buildChip("Google Fonts",
                            [Colors.red, Colors.redAccent], false),
                        buildChip("Material Icons",
                            [Colors.green, Colors.greenAccent], false),
                        buildChip("Dart", [Colors.purple, Colors.purpleAccent],
                            false),
                        buildChip("Android Studio",
                            [Colors.teal, Colors.tealAccent], false),
                        buildChip(
                            "GitHub", [Colors.black, Colors.black], false),
                        buildChip("Provider",
                            [Colors.orange, Colors.orangeAccent], false),
                        buildChip("http", [Colors.brown, Colors.brown], false),
                        buildChip("shared_preferences",
                            [Colors.pink, Colors.pinkAccent], false),
                        buildChip("path_provider",
                            [Colors.cyan, Colors.cyanAccent], false),
                        buildChip("sqflite",
                            [Colors.indigo, Colors.indigoAccent], false),
                        buildChip(
                            "intl", [Colors.amber, Colors.amberAccent], false),
                        buildChip("Hive", [Colors.yellow, Colors.yellowAccent],
                            false),
                        buildChip("bluetooth",
                            [Colors.blueGrey, Colors.lightBlueAccent], false),
                        buildChip("Scout-Ops Windowsapp",
                            [Colors.lightBlue, Colors.lightBlueAccent], false),
                        buildChip("Scout-Ops server",
                            [Colors.green, Colors.greenAccent], false),
                      ],
                    )
                  ])),
            ),
            const SizedBox(height: 16),
            ExpandableTile(
              title: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.teal, Colors.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  'Api & Data',
                  style: GoogleFonts.chivoMono(
                    fontSize: 30,
                    fontWeight: FontWeight.w100,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap_Widget: () {},
              icon_Widget: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.tealAccent, Colors.lightGreen],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: const Icon(Icons.credit_card,
                    color: Colors.white, size: 35),
              ),
              expanded_Widget: true,
              Expanded_Widget: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                    Text(
                      "ScoutOps leverages various APIs and data sources to provide semi-real-time insights and analytics.",
                      style: GoogleFonts.chivoMono(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8.0, // Horizontal space between chips.
                      runSpacing: 4.0, // Vertical space between lines of chips.
                      children: [
                        buildChip("The Blue Alliance",
                            [Colors.blue, Colors.blueAccent], false),
                        buildChip("Scout-Ops-Server",
                            [Colors.green, Colors.greenAccent], false),
                      ],
                    )
                  ])),
            ),
            const SizedBox(height: 16),
            ExpandableTile(
              title: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.yellow, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  'Contact Us',
                  style: GoogleFonts.chivoMono(
                    fontSize: 30,
                    fontWeight: FontWeight.w100,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap_Widget: () {},
              icon_Widget: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.yellowAccent, Colors.orangeAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: const Icon(Icons.contact_mail,
                    color: Colors.white, size: 35),
              ),
              expanded_Widget: true,
              Expanded_Widget: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "For inquiries, reach out to us at: feds201@gmail.com. We look forward to hearing from you!",
                  style: GoogleFonts.chivoMono(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ]),
        ));
  }
}
