import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rx_notifier/rx_notifier.dart';

class CameraController {
  final _picker = ImagePicker();

  FaceDetector faceDetector;

  RxNotifier<bool> loading = RxNotifier(false);
  RxNotifier<File> picture = RxNotifier(null);
  RxNotifier<bool> foundFace = RxNotifier(false);
  RxNotifier<String> error = RxNotifier("");

  initDetector() {
    faceDetector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
        enableLandmarks: true,
        enableClassification: true));
  }

  getImage() async {
    //initDetector();
    loading.value = true;
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      picture.value = File(pickedFile.path);
      await _processImage();
    }
    loading.value = false;
  }

  _processImage() async {
    final FirebaseVisionImage image =
        FirebaseVisionImage.fromFile(picture.value);
    final List<Face> faces = await faceDetector.processImage(image);
    final bool detectedFaces = await _detectFaces(faces);
    foundFace.value = detectedFaces;
  }

  _detectFaces(List<Face> faces) async {
    if (faces.length == 0) {
      error.value = "Nenhum rosto reconhecido.";
      return false;
    }
    for (Face face in faces) {
      final FaceLandmark leftEar = face.getLandmark(FaceLandmarkType.leftEar);
      final FaceLandmark rightYear =
          face.getLandmark(FaceLandmarkType.rightEar);
      final FaceLandmark mouth = face.getLandmark(FaceLandmarkType.bottomMouth);
      final FaceLandmark leftEye = face.getLandmark(FaceLandmarkType.leftEye);
      final FaceLandmark rightEye = face.getLandmark(FaceLandmarkType.rightEye);

      if (leftEar != null &&
          rightEye != null &&
          mouth != null &&
          leftEye != null &&
          rightYear != null) {
        return true;
      }
      error.value = "Centralize seu rosto na foto.";
      return false;
    }
  }
}
