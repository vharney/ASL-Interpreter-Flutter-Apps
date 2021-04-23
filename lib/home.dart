import 'package:flutter/material.dart';
import 'package:slide_button/slide_button.dart';
import 'camera_screen.dart';
import 'package:camera/camera.dart';

class Home extends StatefulWidget {
  final CameraDescription camera;

  const Home({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  int _currentIndex = 0;
//  var tabs = [Home(), CameraScreen(camera:)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Column(
            children: [
              SizedBox(height: 150),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Text(
                    "Hello! \nWelcome to",
                    style: TextStyle(
                      color: Color(0xff878787),
                      fontSize: 25,
                      fontFamily: "Roboto",
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Text(
                    "ASL Interpreter.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Color(0xffffffff),
                      fontSize: 25,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Text(
                    "This app allows you to\ntranslate ASL sign letters \nby using\nImage Detection.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Color(0xff878787),
                      fontSize: 25,
                      fontFamily: "Roboto",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 140),
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.add_a_photo,
                        color: Color(0xff3ACCE1),
                        size: 30,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Use our AI intergrated in the camera \nto detect the letters.",
                          style: TextStyle(
                              color: Color(0xff41A1FF),
                              fontSize: 15,
                              fontFamily: "Roboto"),
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.volume_up,
                        color: Color(0xff3ACCE1),
                        size: 30,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Converts texts to speech\nwith a tap.",
                          style: TextStyle(
                              color: Color(0xff41A1FF),
                              fontSize: 15,
                              fontFamily: "Roboto"),
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.lightbulb,
                        color: Color(0xff3ACCE1),
                        size: 30,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Make sure the hand is well lit\nfor the best results.",
                          style: TextStyle(
                              color: Color(0xff41A1FF),
                              fontSize: 15,
                              fontFamily: "Roboto"),
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 50),
              SlideButton(
                height: 64,
                backgroundChild: Center(
                  child: Text("SlIDE TO START DETECTING",
                    style: TextStyle(
                      color: Color(0xff41A1FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: "Roboto"
                    ),
                   ),
                ),
                backgroundColor: Colors.white,
                slidingBarColor: Colors.blue,
                slideDirection: SlideDirection.RIGHT,
                onButtonOpened: () async {
                  // Obtain a list of the available cameras on the device.
                  final cameras = await availableCameras();

                  // Get a specific camera from the list of available cameras.
                  final firstCamera = cameras.first;

                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CameraScreen(camera: firstCamera)));
                },
              ),
          ]),
    );
  }
}
