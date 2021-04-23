import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'home.dart';
import 'package:flutter/material.dart';
import 'services/tflite-service.dart';
import 'services/camera-service.dart';
import 'dart:async';



class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);


  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
//  final CameraDescription camera = get_camera();
  Future<void> _initializeControllerFuture;
  TensorFlowService _tensorFlowService = TensorFlowService();
  CameraService _cameraService = CameraService();
  final FlutterTts flutterTts = FlutterTts();
//  Prediction _prediction = Prediction();

  // current list of recognition
  List<dynamic> _currentRecognition = [];

  // listens the changes in tensorflow recognitions
  StreamSubscription _streamSubscription;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // starts camera and then loads the tensorflow model
    startUp();
  }

  startRecognitions() async {
    try {
      // starts the camera stream on every frame and then uses it to recognize the result every 1 second
      _cameraService.startStreaming();
    } catch (e) {
      print('error streaming camera image');
      print(e);
    }
  }

  stopRecognitions() async {
    // closes the streams
    await _cameraService.stopImageStream();
    await _tensorFlowService.stopRecognitions();
  }

  Future startUp() async {
    if (!mounted) {
      return;
    }
    if (_initializeControllerFuture == null) {
      _initializeControllerFuture = _cameraService.startService(widget.camera).then((value) async {
        await _tensorFlowService.loadModel();
        startRecognitions();
      });
    } else {
      await _tensorFlowService.loadModel();
      startRecognitions();
    }
  }

  _startRecognitionStreaming() {
    if (_streamSubscription == null) {
      print("HELLO YOU");
      _streamSubscription = _tensorFlowService.recognitionStream.listen((recognition) {
        if (recognition != null) {
          // rebuilds the screen with the new recognitions
          setState(() {
            _currentRecognition = recognition;
          });
        } else {
          _currentRecognition = [];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start Detecting Hand Sign"),
//        leading: IconButton(
//            icon: Icon(Icons.arrow_back, color: Colors.black),
//            onPressed: () {
////              stopRecognitions();
////              _streamSubscription.cancel();
//              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
//            }
//        ),
      ),
      body: FutureBuilder<void> (
        future: _initializeControllerFuture,
        builder: (context,snapshot)  {
//          startUp();
//          return Stack(
//              children:<Widget> [
//                CameraPreview(_cameraService.cameraController),
//                Prediction(),
//              ]
//          );
          if (snapshot.connectionState == ConnectionState.done){
//            startUp();
//            startRecognitions();
            _startRecognitionStreaming();
            return Stack(
                children:<Widget> [
                  CameraPreview(_cameraService.cameraController),
//                  _prediction,
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF120320),
                              ),
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: <Widget>[
                                // shows recognition title
                                _titleWidget(),

                                // shows recognitions list
                                _contentWidget(),
                                ]
                               ),
                          ),
                         ),
                        ],
                       ),
                      ),
                    ),
                ]
            );
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }

  Widget _titleWidget() {
    Future speak(String s) async {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(s);
    }
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(top: 15, left: 20, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Recognitions",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10,0,35,0),
        ),
        FlatButton(
          splashColor: Colors.blueAccent,
          onPressed: () {
            speak("${_currentRecognition[0]['label']}");
          },
          child: Row(
            children: [
              Icon(
                Icons.play_arrow,
                size: 30,
                color: Color(0xff375079),
              ),
              Text("Text-to-Speech"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _contentWidget() {
    var _width = MediaQuery.of(context).size.width;
    var _padding = 20.0;
    var _labelWitdth = 150.0;
    var _labelConfidence = 30.0;
    var _barWitdth = _width - _labelWitdth - _labelConfidence - _padding * 2.0;

    if (_currentRecognition.length > 0) {
      return Container(
        height: 150,
        child: ListView.builder(
          itemCount: _currentRecognition.length,
          itemBuilder: (context, index) {
            if (_currentRecognition.length > index) {
              print(_currentRecognition[index]['label']);
              return Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: _padding, right: _padding),
                      width: _labelWitdth,
                      child: Text(
                        _currentRecognition[index]['label'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: _barWitdth,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        value: _currentRecognition[index]['confidence'],
                      ),
                    ),
                    Container(
                      width: _labelConfidence,
                      child: Text(
                        (_currentRecognition[index]['confidence'] * 100).toStringAsFixed(0) + '%',
                        maxLines: 1,
//                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  ],
                ),
              );

            } else {
              return Container();
            }
          },
        ),
      );
    } else {
      return Text('');
    }
  }


  void dispose() {
    _streamSubscription?.cancel();
    _cameraService.dispose();
    _tensorFlowService.dispose();
    _initializeControllerFuture = null;
//    _streamSubscription?.cancel();
    super.dispose();
  }
}
