import 'dart:async';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

class TensorFlowService {
  // singleton boilerplate
  static final TensorFlowService _tensorflowService = TensorFlowService._internal();

  factory TensorFlowService() {
    return _tensorflowService;
  }
  // singleton boilerplate
  TensorFlowService._internal();

  // ignore: close_sinks
  StreamController<List<dynamic>> _recognitionController = StreamController<List<dynamic>>.broadcast();
  Stream get recognitionStream => this._recognitionController.stream;

  bool _modelLoaded = false;

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/model_72.tflite",
        labels: "assets/labels.txt",
      );
      _modelLoaded = true;
    } catch (e) {
      print('error loading model');
      print(e);
    }
  }

  Future<void> runModel(CameraImage img) async {
    if (_modelLoaded) {
      List<dynamic> recognitions = await Tflite.runModelOnFrame(
        bytesList: img.planes.map((plane) {
          return plane.bytes;
        }).toList(), // required
        imageHeight: img.height,
        imageWidth: img.width,
        numResults: 3,
      );
      print(recognitions);
      // shows recognitions on screen
      if (recognitions.isNotEmpty) {
        print(recognitions[0].toString());
        if (this._recognitionController.isClosed) {
          // restart if was closed
          this._recognitionController = StreamController();
        }
//        // notify to listeners
        this._recognitionController.add(recognitions);
      }
    }
  }

  Future<void> stopRecognitions() async {
    if (!this._recognitionController.isClosed) {
      this._recognitionController.add(null);
      this._recognitionController.close();
    }
  }

  void dispose() async {
    Tflite.close();
    this._recognitionController.close();
  }

}
