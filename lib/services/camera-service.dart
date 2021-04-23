import 'package:camera/camera.dart';
import 'tflite-service.dart';

class CameraService {
  // singleton boilerplate
  static final CameraService _cameraService = CameraService._internal();

  factory CameraService() {
    return _cameraService;
  }
  // singleton boilerplate
  CameraService._internal();

  TensorFlowService _tensorFlowService = TensorFlowService();

  bool available = true;
  CameraController _cameraController;
  CameraController get cameraController => _cameraController;

  Future startService(CameraDescription cameraDescription) async {
//    print(cameraDescription);
    _cameraController = CameraController(
      // Get a specific camera from the list of available cameras.
      cameraDescription,
      // Define the resolution to use.
      ResolutionPreset.low,
    );

    // Next, initialize the controller. This returns a Future.
    return _cameraController.initialize();
  }

  Future<void> startStreaming() async {
    _cameraController.startImageStream((img) async {
      try {
        if (available) {
          // Loads the model and recognizes frames
          available = false;
          await _tensorFlowService.runModel(img);
          await Future.delayed(Duration(seconds: 1));
          available = true;
        }
      } catch (e) {
        print('error running model with current frame');
        print(e);
      }
    });
  }

  Future stopImageStream() async {
    await this._cameraController.stopImageStream();
  }

  dispose() {
    _cameraController.dispose();
  }
}

