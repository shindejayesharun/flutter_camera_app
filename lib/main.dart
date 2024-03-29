import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shreyas_camera_assignment/camera_screen.dart';


const Color barColor = const Color(0x20000000);

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        bottomAppBarColor: barColor,
      ),
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _cameraKey = GlobalKey<CameraScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).backgroundColor,
      body: CameraScreen(
        key: _cameraKey,
      ),
    );
  }
}