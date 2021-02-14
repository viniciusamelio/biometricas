import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:rx_notifier/rx_notifier.dart';

class FaceDetectorService {
  FaceDetector faceDetector;

  initDetector() {
    faceDetector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
        enableLandmarks: true,
        enableClassification: true));
  }

  processImage(File file, RxNotifier<bool> found, double percentage,
      RxNotifier<String> errorFeedbackListener) async {
    final FirebaseVisionImage image = FirebaseVisionImage.fromFile(file);
    final List<Face> faces = await faceDetector.processImage(image);
    final bool detectedFaces = await _detectFaces(faces, errorFeedbackListener);
    found.value = detectedFaces;
  }

  _detectFaces(
      List<Face> faces, RxNotifier<String> errorFeedbackListener) async {
    if (faces.length == 0) {
      errorFeedbackListener.value = "Nenhum rosto reconhecido.";
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
      errorFeedbackListener.value = "Centralize seu rosto na foto.";
      return false;
    }
  }
}
