import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dotted_border/dotted_border.dart';

class StopwatchWidget extends StatefulWidget {
  final Function(double time)? onStopped;
  final double time;

  const StopwatchWidget({super.key, required this.time, this.onStopped});

  @override
  _StopwatchWidgetState createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  late int _initialElapsedMilliseconds;

  @override
  void initState() {
    super.initState();
    _setInitialTime(widget.time);
  }

  void _setInitialTime(double time) {
    _initialElapsedMilliseconds =
        (time * 1000).toInt(); // Convert seconds to milliseconds
  }

  void _startStopwatch() {
    setState(() {
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
        setState(() {});
      });
    });
  }

  void _stopStopwatch() {
    setState(() {
      _stopwatch.stop();
      _timer?.cancel();
      widget.onStopped?.call(
          (_stopwatch.elapsedMilliseconds + _initialElapsedMilliseconds) /
              1000);
    });
  }

  void _resetStopwatch() {
    setState(() {
      _stopwatch.reset();
      _timer?.cancel();
      _initialElapsedMilliseconds = 0; // Reset the initial elapsed time as well
    });
  }

  String _formatTime(int milliseconds) {
    final totalMilliseconds = milliseconds + _initialElapsedMilliseconds;
    final seconds = (totalMilliseconds / 1000).floor();
    final milliSeconds = (totalMilliseconds % 1000) ~/ 100;
    return '$seconds.${milliSeconds.toString().padLeft(1, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  padding: const EdgeInsets.all(6),
                  color: Colors.blueAccent,
                  dashPattern: const [8, 4],
                  strokeWidth: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            '${_formatTime(_stopwatch.elapsedMilliseconds)}s',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: _stopwatch.isRunning
                                  ? _stopStopwatch
                                  : _startStopwatch,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _stopwatch.isRunning
                                    ? Colors.red
                                    : Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                              ),
                              child: Text(
                                _stopwatch.isRunning ? 'Stop' : 'Start',
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _resetStopwatch,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                              ),
                              child: const Text(
                                'Reset',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: StopwatchWidget(
        time: 10.0, // Set initial time to 10 seconds
        onStopped: (time) {
          print('Stopwatch stopped at $time seconds');
        },
      ),
    ),
  ));
}
