import 'package:flutter/material.dart';


import 'components/nav.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: homePage(),
    );
  }
}

Widget homePage(){
  return OrientationBuilder(
      builder: (context, orientation) {
        String textToDisplay;
        if (orientation == Orientation.portrait) {
          textToDisplay = 'Welcome to the FRC FEDS Team Scouting App, your all-in-one companion for the ultimate robotics scouting experience. Designed by and for enthusiasts of the FIRST Robotics Competition, our app empowers teams with real-time data and insights to strategize effectively during competitions. From tracking robot performance and match outcomes to analyzing opponent strengths, our intuitive interface ensures that every decision on the field is backed by comprehensive scouting intelligence. Join us in revolutionizing how teams compete and collaborate in the thrilling world of FRC.';
        } else {
          textToDisplay = 'Welcome to the Scouting App 2024!';
        }

        return Container(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 158, 158),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    textToDisplay,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 5, 5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Welcome to the Scouting App 2024!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 238, 106, 106),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Welcome to the Scouting App 2024!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
