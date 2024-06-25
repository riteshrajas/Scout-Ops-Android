import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scouting_app/main.dart'; // Import this if `thumbIcon` is defined in `main.dart`

import 'components/nav.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool isLocationGranted = false;
  bool isBluetoothGranted = false;
  bool isNearbyDevicesGranted = false;

  @override
  void initState() {
    super.initState();
    _checkInitialPermissions();
  }

  Future<void> _checkInitialPermissions() async {
    var locationStatus = await Permission.location.status;
    var bluetoothStatus = await Permission.bluetooth.status;
    var nearbyDevicesStatus = await Permission.bluetoothAdvertise.status;

    setState(() {
      isLocationGranted = locationStatus.isGranted;
      isBluetoothGranted = bluetoothStatus.isGranted;
      isNearbyDevicesGranted = nearbyDevicesStatus.isGranted;
    });
  }

  Future<void> _requestPermission(Permission permission, bool currentValue, Function(bool) onChanged) async {
    if (currentValue) {
      if (await permission.request().isGranted) {
        onChanged(true);
      } else {
        onChanged(false);
      }
    } else {
      onChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color.fromARGB(255, 241, 255, 241),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Scout Name',
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
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 241, 255, 241),
              ),
              child: Column(
                children: [
                  // Switch for Location permission
                  SwitchListTile(
                    tileColor: const Color.fromARGB(255, 241, 255, 241),
                    contentPadding: const EdgeInsets.only(left: 10, right: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: const Text("Location"),
                    thumbIcon: thumbIcon,
                    value: isLocationGranted,
                    onChanged: (bool value) {
                      _requestPermission(Permission.location, value, (newValue) {
                        setState(() {
                          isLocationGranted = newValue;
                        });
                      });
                    },
                    activeTrackColor: const Color.fromARGB(255, 11, 243, 11),
                    activeColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  // Switch for Bluetooth permission
                  SwitchListTile(
                    tileColor: const Color.fromARGB(255, 241, 255, 241),
                    contentPadding: const EdgeInsets.only(left: 10, right: 10),
                    thumbIcon: thumbIcon,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: const Text("Bluetooth"),
                    value: isBluetoothGranted,
                    onChanged: (bool value) {
                      _requestPermission(Permission.bluetooth, value, (newValue) {
                        setState(() {
                          isBluetoothGranted = newValue;
                        });
                      });
                    },
                    activeTrackColor: const Color.fromARGB(255, 11, 243, 11),
                    activeColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  // Switch for Nearby Devices permission
                  SwitchListTile(
                    tileColor: const Color.fromARGB(255, 241, 255, 241),
                    contentPadding: const EdgeInsets.only(left: 10, right: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: const Text("Nearby Devices"),
                    thumbIcon: thumbIcon,
                    value: isNearbyDevicesGranted,
                    onChanged: (bool value) {
                      _requestPermission(Permission.bluetoothAdvertise, value, (newValue) {
                        setState(() {
                          isNearbyDevicesGranted = newValue;
                        });
                      });
                    },
                    activeTrackColor: const Color.fromARGB(255, 11, 243, 11),
                    activeColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final WidgetStateProperty<Icon?> thumbIcon =
WidgetStateProperty.resolveWith<Icon?>(
      (Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return const Icon(Icons.check);
    }
    return const Icon(Icons.close);
  },
);