import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../Plugins/plugins.dart';
import '../components/DataBase.dart';
import '../components/nav.dart';
import 'match.dart';
import 'match_Selection.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  MatchPageState createState() => MatchPageState();
}

class MatchPageState extends State<MatchPage> {
  final TextEditingController eventKeyController = TextEditingController();
  Future<List<dynamic>>? matches;
  bool isLoading = false;
  int _selectedIndex = 0;
  int _selectedMatchType = 0; // New state variable for NavigationRail
  String eventKey = '';

  @override
  void initState() {
    super.initState();
    try {
      eventKey = LocalDataBase.getData(Types.eventKey) ?? '';
      eventKeyController.text = eventKey;
      matches = LocalDataBase.getMatchData() as Future<List>?;
      matches?.then((data) {
        developer.log(jsonEncode(data)); // Print the data once it is fetched
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: _buildCustomAppBar(context),
      body: matchPage(context, _selectedIndex), // Main content area
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setup',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Match',
          ),
        ],
        currentIndex: _selectedIndex.clamp(
            0, 1), // Ensure currentIndex is within valid range
        selectedItemColor: Colors.red,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  AppBar _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Transparent to show the animation
      title: Center(
        child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.red, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
            child: Text(
              'Match Page',
              style: GoogleFonts.museoModerno(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            )),
      ),
      elevation: 0, // Remove shadow for a cleaner look
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Clear all data',
          onPressed: () {
            isLoading = true;
            setState(() {
              matches = null;
              LocalDataBase.putData(Types.eventFile, null);
              LocalDataBase.putData(Types.eventKey, null);
              eventKeyController.text = '';
              LocalDataBase.putData(Types.allianceColor, null);
              LocalDataBase.putData(Types.selectedStation, null);
              LocalDataBase.putData(Types.matchFile, null);
              LocalDataBase.putData(Types.matchKey, null);
            });
          },
        ),
      ],
    );
  }

  Widget matchPage(BuildContext context, int selectedIndex) {
    return selectedIndex == 0
        ? setup(context)
        : FutureBuilder<List<dynamic>>(
            future: matches,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No data available!',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Please ensure you are connected to the internet.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Verify the event key and try again.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Check the API key in the settings page.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return matchSelection(context, _selectedMatchType, (int index) {
                  setState(() {
                    _selectedMatchType = index;
                  });
                }, jsonEncode(snapshot.data));
              }
            },
          );
  }

  void prepopulateData() {
    try {
      var data = Hive.box("matchData").get("matches", defaultValue: null);
      LocalDataBase.putData(Types.eventFile, data.toString());
      LocalDataBase.putData(Types.eventKey, data[0]['event_key']);
      eventKeyController.text = LocalDataBase.getData(Types.eventKey);
      writeJson(data);
      developer.log(data.toString());
      setState(() {
        matches = readJson();
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load data');
        print(e);
        print(isLoading);
      }
      setState(() {
        isLoading = true;
      });
    }
  }

  Future<void> prepopulateDataServer() async {
    var box = Hive.box('settings');
    String ipAddress = box.get('ipAddress', defaultValue: '');
    String url = 'http://$ipAddress/get_event_file';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // developer.log(data[0]['event_key']);
        Hive.box('matchData').put('matches', (data));
        LocalDataBase.putData(Types.eventFile, data.toString());
        LocalDataBase.putData(Types.eventKey, data[0]['event_key']);
        eventKeyController.text = LocalDataBase.getData(Types.eventKey);
        writeJson(data);
        setState(() {
          matches = readJson();
          isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load data');
        print(e);
      }
      setState(() {
        isLoading = true;
      });
    }
  }

  List<Widget> modules(BuildContext context) {
    return [
      const SizedBox(height: 10),
      TextField(
        controller: eventKeyController,
        decoration: InputDecoration(
          labelText: 'Match Event Key (e.g. 2022miket)',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      const SizedBox(height: 10),
      const SizedBox(height: 10),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isLoading ? Colors.redAccent : Colors.green[300],
                  border: Border.all(
                    color: isLoading ? Colors.red : Colors.green,
                    width: 3,
                  ),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width / 2, 50),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Colors.blue,
                      width: 3,
                    ),
                  ),
                ),
                onPressed: () => getData(eventKeyController.text),
                child: Text(
                  'Load Event',
                  style: GoogleFonts.museoModerno(
                      fontSize: 15, color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 50),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.redAccent[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Colors.red,
                      width: 3,
                    ),
                  ),
                ),
                onPressed: () {
                  prepopulateData();
                },
                onLongPress: () {
                  prepopulateDataServer();
                },
                child: Text('Use Local',
                    style: GoogleFonts.museoModerno(
                        fontSize: 15, color: Colors.white)),
              ),
            ],
          )),
      const SizedBox(height: 20),
      Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Container(
            margin: const EdgeInsets.only(left: 5),
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    LocalDataBase.getData(Types.allianceColor) == 'Red'
                        ? Colors.redAccent[400]
                        : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.red, width: 3),
                ),
              ),
              onPressed: () {
                setState(() {
                  LocalDataBase.putData(Types.allianceColor, 'Red');
                });
              },
              child: Text(
                'Red',
                style:
                    GoogleFonts.museoModerno(fontSize: 20, color: Colors.white),
              ),
            ),
          )),
          Expanded(
              child: Container(
            margin: const EdgeInsets.only(right: 5),
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    LocalDataBase.getData(Types.allianceColor) == 'Blue'
                        ? Colors.blueAccent[400]
                        : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.blueAccent, width: 3),
                ),
              ),
              onPressed: () {
                setState(() {
                  LocalDataBase.putData(Types.allianceColor, 'Blue');
                });
              },
              child: Text(
                'Blue',
                style:
                    GoogleFonts.museoModerno(fontSize: 20, color: Colors.white),
              ),
            ),
          )),
        ],
      ),
      if (LocalDataBase.getData(Types.allianceColor) == "Red") ...[
        Column(
          children: [
            const SizedBox(height: 20),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        LocalDataBase.putData(Types.selectedStation, 'R1');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            LocalDataBase.getData(Types.selectedStation) == "R1"
                                ? Colors.redAccent
                                : Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side:
                                const BorderSide(color: Colors.red, width: 3))),
                    child: Text('R1',
                        style: GoogleFonts.museoModerno(
                          fontSize: 15,
                        )),
                  ),
                )),
                Expanded(
                    child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        LocalDataBase.putData(Types.selectedStation, 'R2');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            LocalDataBase.getData(Types.selectedStation) == "R2"
                                ? Colors.redAccent
                                : Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side:
                                const BorderSide(color: Colors.red, width: 3))),
                    child: Text('R2',
                        style: GoogleFonts.museoModerno(
                          fontSize: 15,
                        )),
                  ),
                )),
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        LocalDataBase.putData(Types.selectedStation, 'R3');
                      });
                    },
                    //change the color when selected

                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            LocalDataBase.getData(Types.selectedStation) == "R3"
                                ? Colors.redAccent
                                : Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.red, width: 3))),
                    child: Text('R3',
                        style: GoogleFonts.museoModerno(
                          fontSize: 15,
                        )),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 20),
            Center(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Image.asset(
            'assets/${LocalDataBase.getData(Types.allianceColor)}Alliance.png',
            width: MediaQuery.of(context).size.width * 0.90,
          ),
        ),
      ),
    ],
  ),
)
          ],
        ),
      ] else if (LocalDataBase.getData(Types.allianceColor) == "Blue") ...[
        Column(
          children: [
            const SizedBox(height: 20),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        LocalDataBase.putData(Types.selectedStation, 'B1');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            LocalDataBase.getData(Types.selectedStation) == "B1"
                                ? Colors.blueAccent
                                : Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Colors.blueAccent, width: 3))),
                    child: Text('B1',
                        style: GoogleFonts.museoModerno(
                          fontSize: 15,
                        )),
                  ),
                )),
                Expanded(
                    child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        LocalDataBase.putData(Types.selectedStation, 'B2');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            LocalDataBase.getData(Types.selectedStation) == "B2"
                                ? Colors.blueAccent
                                : Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Colors.blueAccent, width: 3))),
                    child: Text('B2',
                        style: GoogleFonts.museoModerno(
                          fontSize: 15,
                        )),
                  ),
                )),
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        LocalDataBase.putData(Types.selectedStation, 'B3');
                      });
                    },
                    //change the color when selected

                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            LocalDataBase.getData(Types.selectedStation) == "B3"
                                ? Colors.blueAccent
                                : Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Colors.blueAccent, width: 3))),
                    child: Text('B3',
                        style: GoogleFonts.museoModerno(
                          fontSize: 15,
                        )),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/${LocalDataBase.getData(Types.allianceColor)}Alliance.png',
                    width: MediaQuery.of(context).size.width * 0.90,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    ];
  }

  void getData(String eventKey) async {
    setState(() {
      isLoading = true;
    });
    var ApiKey = Settings.getApiKey();
    print(ApiKey);
    var headers = {
      'X-TBA-Auth-Key': ApiKey,
    };
    var response = await http.get(
        Uri.parse(
            'https://www.thebluealliance.com/api/v3/event/$eventKey/matches'),
        headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      LocalDataBase.putData(Types.eventFile, data.toString());
      await writeJson(data);
      setState(() {
        matches = readJson();
        isLoading = false;
      });
    } else {
      if (kDebugMode) {
        print('Failed to load data');
      }
      setState(() {
        isLoading = true;
      });
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> writeJson(List<dynamic> data) async {
    final path = await _localPath;
    final file = File('$path/data.json');
    return file.writeAsString(jsonEncode(data));
  }

  Future<List<dynamic>> readJson() async {
    try {
      final path = await _localPath;
      final file = File('$path/data.json');
      final contents = await file.readAsString();
      return jsonDecode(contents);
    } catch (e) {
      return [];
    }
  }

  Widget setup(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: modules(context),
        ),
      ),
    );
  }
}
