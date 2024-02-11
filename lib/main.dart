import 'package:flutter/material.dart';
import 'package:nt4/nt4.dart';
import 'package:logger/logger.dart';
// import 'package:fullscreen_window/fullscreen_window.dart';

void main() {
  // var fullScreenState = false;
  // toggleFullScreen(fullScreenState);
  networkTables();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pink,
            title: const Text('4788 Dashboard'),
          ),
          body: Container(
            margin: const EdgeInsets.all(100.0),
            padding: const EdgeInsets.all(20.0),
            height: 100,
            width: 400,
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            child: const Text('Welcome to 4788 Dashboard'),
          ),
        ),
      ),
    );
  }
}

void networkTables() async {
  var logger = Logger();
  // Connect to NT4 server at 10.47.88.2
  NT4Client client = NT4Client(
    serverBaseAddress: '10.47.88.2',
    onConnect: () {
      logger.i('\nNT4 Client Connected\n');
    },
    onDisconnect: () {
      logger.w('\nNT4 Client Disconnected\n');
    },
  );

  // Subscribe to a topic
  NT4Subscription exampleSub =
      client.subscribePeriodic('/SmartDashboard/DB/Slider 0');

  // Recieve data from subscription with a callback or stream
  exampleSub.listen((data) => logger.i('Recieved data from callback: $data'));

  await for (Object? data in exampleSub.stream()) {
    logger.i('Recieved data from stream: $data');
  }
}

// void toggleFullScreen(bool fullScreenState) {
//   fullScreenState = !fullScreenState;
//   if (fullScreenState) {
//     FullscreenWindow.enterFullscreen();
//   } else {
//     FullscreenWindow.exitFullscreen();
//   }
// }
