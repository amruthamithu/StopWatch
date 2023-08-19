import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stopwatch/list.dart';

class StopwatchScreen extends StatefulWidget {
  final String userName;

  const StopwatchScreen(this.userName, {super.key});

  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  bool _isRunning = false;
  String _result = '00:00:00';
  late Timer _timer;
  final Stopwatch _stopwatch = Stopwatch();
  final List<String> _savedTimes = [];

  void _toggleTimer() {
    if (_isRunning) {
      _stopwatch.stop();
      _isRunning = false;
    } else {
      _start();
      _isRunning = true;
    }
    setState(() {});
  }

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      setState(() {
        _result =
            '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
      });
    });

    _stopwatch.start();
  }

  void _saveTime() {
    _savedTimes.add("${widget.userName}: $_result seconds");
    _stopwatch.reset();
    _isRunning = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timer')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListScreen(),
                    ),
                  );
                },
                child: const Text('View'),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                '$_result ',
                style: const TextStyle(fontSize: 45),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _toggleTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRunning
                          ? Colors.red
                          : Colors.green, // Use ternary operator to set color
                    ),
                    child: Text(_isRunning ? 'Stop' : 'Start'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: _saveTime,
                    child: const Text('Save'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const ListScreen(),
              //       ),
              //     );
              //   },
              //   child: const Text('Save'),
              // ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _savedTimes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_savedTimes[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }
}
