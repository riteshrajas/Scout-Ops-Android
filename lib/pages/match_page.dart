import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'components/nav.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'match.dart';


class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  MatchPageState createState() => MatchPageState();
}



class MatchPageState extends State<MatchPage> {
  final TextEditingController eventKeyController = TextEditingController();
  String? allianceColor;
  String? selectedStation;
  Future<List<dynamic>>? matches;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),

      appBar: AppBar(
        title: const Text('Match'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              setState(() {
                matches = null;
                allianceColor = null;
                eventKeyController.clear();
              });
            },
          ),
        ],

      ),
      body: matchPage(context),

    );
  }

  Widget matchPage(BuildContext context) {
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

  List<Widget> modules(BuildContext context) {
    return [
      const SizedBox(height: 10),
      TextField(
        controller: eventKeyController,
        decoration: InputDecoration(
          labelText: 'Match Event Key (e.g. 2023cmptx)',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Add a circle red/green indicator to show if the data is loaded

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: matches == null ? Colors.red : Colors.green,
              shape: BoxShape.circle,
            ),
          ),

          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width / 2, 50),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                onPressed: () => getData(eventKeyController.text),
                child: const Text('Load Event'),
              ),
            ],
          ),

          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 50),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  Match(allianceColor: allianceColor, eventKey: eventKeyController.text , matchKey: '', station: selectedStation,),
                    ),
                  );
                },
                child: const Text('Next'),
              ),
            ],
          )
        ],
      ),


      const SizedBox(height: 30),
      Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      allianceColor == 'Red' ? Colors.red : Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.red)),
                ),
                onPressed: () {
                  setState(() {
                    allianceColor = 'Red';
                  });
                },
                child: const Text('Red'),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      allianceColor == 'Blue' ? Colors.blue : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.blue),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    allianceColor = 'Blue';
                  });
                },
                child: const Text('Blue'),
              ),
            ),
          ),
        ],
      ),

      if (allianceColor == "Red") ...[
        const SizedBox(height: 30),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              ElevatedButton( child: const Text('R1'), onPressed: () {
                setState(() {
                  selectedStation = "R1";
                });
              }, ),
              const SizedBox(width: 60),
              ElevatedButton( child: const Text('R2'), onPressed: () {
                setState(() {
                  selectedStation = "R2";
                });
              }, ),
              const SizedBox(width: 60),
              ElevatedButton( child: const Text('R3'), onPressed: () {
                setState(() {
                  selectedStation = "R3";
                });
              }, ),
            ],
          )
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/${allianceColor}Alliance.png',
                width: MediaQuery.of(context).size.width * 0.90,
              ),
            ],
          ),
        )
      ]
      else if (allianceColor == "Blue") ...[
        const SizedBox(height: 30),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton( child: const Text('B1'), onPressed: () {
                setState(() {
                  selectedStation = "B1";
                });
              }, ),
              const SizedBox(width: 60),
              ElevatedButton( child: const Text('B2'), onPressed: () {
                setState(() {
                  selectedStation = "B2";
                });
              }, ),
              const SizedBox(width: 60),
              ElevatedButton( child: const Text('B3'), onPressed: () {
                setState(() {
                  selectedStation = "B3";
                });
              }, ),
            ],
          )
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/${allianceColor}Alliance.png',
                width: MediaQuery.of(context).size.width * 0.90,
              ),
            ],
          ),
        )
      ]
    ];
  }

  getData(String eventKey) async {
    // Step 1: Get the data from the API
    // Step 2: Parse the json data
    // Step 3: Update the UI
    // Step 4: Error handling
    // Step 5: Write data to the file
    // Step 6: Read data from the file
    // Step 7: print the data

    var headers = {
      'X-TBA-Auth-Key':
          '2ujRBcLLwzp008e9TxIrLYKG6PCt2maIpmyiWtfWGl2bT6ddpqGLoLM79o56mx3W\t'
    };
    var response = await http.get(
        Uri.parse(
            'https://www.thebluealliance.com/api/v3/event/$eventKey/matches'),
        headers: headers);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (kDebugMode) {
        print(data);
      }

      await writeJson(data);

      setState(() {
        matches = readJson();
      });
    } else {
      if (kDebugMode) {
        print('Failed to load data');
      }
    }
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> writeJson(List<dynamic> data) async {
  final path = await _localPath;
  final file = File('$path/data.json');

  // Convert the List to a JSON string and write it to the file
  return file.writeAsString(jsonEncode(data));
}

Future<List<dynamic>> readJson() async {
  try {
    final path = await _localPath;
    final file = File('$path/data.json');

    // Read the file and parse the JSON data
    final contents = await file.readAsString();
    return jsonDecode(contents);
  } catch (e) {
    // If encountering an error, return an empty List
    return [];
  }
}
