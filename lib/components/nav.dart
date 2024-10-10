import 'package:flutter/material.dart';
import 'package:scouting_app/Experiment/experiment.dart';

import '../Match_Pages/about_page.dart';
import '../Match_Pages/logs.dart';
import '../Match_Pages/match_page.dart';
import '../Match_Pages/settings_page.dart';
import '../home_page.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width *
          1, // Drawer width is 60% of the screen width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.grey, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              height: 200,
              width: double.infinity,
              // This makes the width of the header fill the drawer
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white30, // Red avatar background
                    radius: 30,
                    child: Icon(
                      Icons.local_police_outlined,
                      size: 35,
                      color: Colors.white, // White icon for a clean contrast
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'FEDS 201',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Scout Ops v.1.5',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70, // Slightly dimmed white text
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.home_outlined,
                  title: 'Home',
                  page: const HomePage(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.sports_score_outlined,
                  title: 'Match',
                  page: const MatchPage(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.list_alt_outlined,
                  title: 'Logs',
                  page: const LogsPage(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  page: const SettingsPage(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'About',
                  page: const AboutPage(),
                ),
              ],
            ),
          ),
          _buildNavItem(context,
              icon: Icons.science_outlined,
              title: 'Experimental',
              page: Experiment()),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required IconData icon, required String title, required Widget page}) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      leading: Icon(icon, color: Colors.blueGrey[700], size: 28),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}
