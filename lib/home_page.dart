import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scouting_app/Plugins/plugins.dart';
import 'package:scouting_app/References.dart';

import 'Match_Pages/match_page.dart';
import 'Pit_Recorder/Pit_Recorder.dart';
import 'components/Button.dart';
import 'components/nav.dart';
import 'templateBuilder/builder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.attach_file_rounded),
              onPressed: () {
                Route route = MaterialPageRoute(
                    builder: (context) => InfiniteZoomImage());
                Navigator.push(context, route);
              },
            ),
            IconButton(
              icon: const Icon(Icons.extension),
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (context) => const Plugins());
                Navigator.push(context, route);
              },
            ),
          ],
        ),
        body: homePage(),
        bottomSheet: _buildPersistentBottomSheet(),
      ),
    );
  }

  Widget _buildPersistentBottomSheet() {
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return Container(
          height: 300,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(
                  child: Column(
                    children: [
                      buildButton(
                        context: context,
                        text: 'Start a match',
                        color: Colors.green.shade100,
                        borderColor: Colors.green.shade800,
                        icon: Icons.play_arrow_outlined,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MatchPage()));
                        },
                      ),
                      const SizedBox(height: 10),
                      buildButton(
                        context: context,
                        text: 'Record Pit',
                        color: Colors.blue.shade100,
                        borderColor: Colors.blueAccent,
                        icon: Icons.bookmark_add_outlined,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Pit_Recorder()));
                        },
                      ),
                      const SizedBox(height: 10),
                      buildButton(
                        context: context,
                        text: 'Create a Template -- Not Implemented',
                        color: Colors.red.shade100,
                        borderColor: Colors.redAccent,
                        icon: Icons.style_outlined,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TemplateEditor()));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget homePage() {
    return HOME();
  }

  Widget HOME() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 30.0),
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.red, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              'Scout-Ops',
              style: GoogleFonts.chivoMono(
                fontSize: 70,
                fontWeight: FontWeight.w100,
                color: Colors
                    .white, // This color is required but will be overridden by the gradient
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.red, Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              'DEVELOPED BY FEDS201',
              style: GoogleFonts.chivoMono(
                fontSize: 20,
                fontWeight: FontWeight.w100,
                color: Colors
                    .white, // This color is required but will be overridden by the gradient
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
