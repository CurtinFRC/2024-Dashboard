import 'package:flutter/material.dart';
// import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:nt4/nt4.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart'; // For SystemChrome and SystemUiMode
import 'package:dotted_border/dotted_border.dart'; // For Dotted Borders

void main() {
  var logger = Logger();
  Map<String, dynamic> widget = {"name": "Pink Widget", "Draggable": true, };
  widget['Type'] = "RPM";

  List<Map<String, dynamic>> activeWidgets = [widget];

  activeWidgets.add({"name": "Blue Widget", "Draggable": true, "Type": "Voltage"});

  // Accessing values in order
  StringBuffer logMessage = StringBuffer();
  for (var entry in activeWidgets) {
    for (var key in entry.keys) {
      logMessage.write('$key: ${entry[key]} \n');
    }
  }
  logger.i(logMessage);

  // networkTables();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var windowWidth = MediaQuery.of(context).size.width;
    var windowHeight = MediaQuery.of(context).size.height;
    var logger = Logger();


    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey, // Assign the GlobalKey to the Scaffold
        appBar: AppBar(
          title: const Text('FRC 4788 Dashboard'),
        ),
        drawer: Drawer(
          backgroundColor: Colors.grey,
          child: Column(
            children: [
              Draggable(
                data: DragData(id: 'pinkWidget'),
                feedback: PinkWidget(
                  windowHeight: windowHeight,
                  windowWidth: windowWidth,
                ),
                childWhenDragging: PinkWidgetDraggingFiller(
                  windowHeight: windowHeight,
                  windowWidth: windowWidth,
                ),
                child: PinkWidget(
                  windowHeight: windowHeight,
                  windowWidth: windowWidth,
                ),
                onDragStarted: () {
                  // Close the drawer when dragging starts
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            ],
          ),
        ),
        body: DragTarget<DragData>(
          builder: (BuildContext context, List<DragData?> candidateData,
              List<dynamic> rejectedData) {
            // Build the UI for the DragTarget
            return Container(
              color: const Color.fromARGB(255, 255, 124, 168),
              width: windowWidth,
              height: windowHeight,
            );
          },
          onWillAccept: (dynamic data) {
            // Always return true to accept all data
            // activeWidgets.append(data);
            return true;
          },
          onAccept: (dynamic data) {
            logger.i('Accepted data: $data');
            // Handle the accepted data
          },
        ),
      ),
    );
  }
}

class DragData {
  final String id;

  DragData({required this.id});
}

class PinkWidget extends StatefulWidget {
  final double windowHeight;
  final double windowWidth;

  const PinkWidget(
      {Key? key, required this.windowHeight, required this.windowWidth})
      : super(key: key);

  @override
  State<PinkWidget> createState() => _PinkWidgetState();
}

class _PinkWidgetState extends State<PinkWidget> {
  late double windowWidth = widget.windowWidth;
  late double windowHeight = widget.windowHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      //Material to remove the orange underline: https://stackoverflow.com/questions/47114639/yellow-lines-under-text-widgets-in-flutter
      child: Container(
        width: (windowWidth - 100) / 6,
        height: (windowHeight - 100) / 6,
        decoration: BoxDecoration(
          color: Colors.pink,
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: const Center(
          child: Text(
            "Placeholder Title",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class PinkWidgetDraggingFiller extends StatelessWidget {
  final double windowHeight;
  final double windowWidth;

  const PinkWidgetDraggingFiller(
      {Key? key, required this.windowHeight, required this.windowWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (windowWidth - 100) / 6,
      height: (windowHeight - 100) / 6,
      decoration: BoxDecoration(
        color: Colors.pinkAccent,
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      ),
    );
  }
}

class DottedRectWidget extends StatelessWidget {
  final double windowHeight;
  final double windowWidth;

  const DottedRectWidget(
      {Key? key, required this.windowHeight, required this.windowWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: DottedBorder(
        dashPattern: const [10, 5],
        borderType: BorderType.Rect,
        borderPadding: const EdgeInsets.all(1),
        strokeWidth: 4,
        color: const Color.fromARGB(121, 187, 178, 178),
        child: Container(
          height: 100,
          width: 200,
          color: Colors.white,
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
  NT4Subscription exampleSub = client.subscribePeriodic('/SmartDashboard/DB/');

  // Recieve data from subscription with a callback or stream
  exampleSub.listen((data) => logger.i('Recieved data from callback: $data'));
  // exampleSub.stream(yieldAll: true);

  await for (Object? data in exampleSub.stream(yieldAll: true)) {
    logger.i('Recieved data from stream: $data');
  }
}

void toggleFullScreen(bool fullScreenState) {
  var logger = Logger();
  fullScreenState = !fullScreenState;
  logger.i(fullScreenState);
  if (fullScreenState) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  } else {}
}
