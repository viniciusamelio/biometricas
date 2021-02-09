import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rx_notifier/rx_notifier.dart';

class CameraController {
  final _picker = ImagePicker();

  FaceDetector faceDetector;

  ValueNotifier<bool> loaded = RxNotifier(false);
  ValueNotifier<File> picture = RxNotifier(null);
  ValueNotifier<bool> foundFace = RxNotifier(false);

  initDetector() {
    faceDetector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
        enableLandmarks: true,
        enableClassification: true));
  }

  getImage() async {
    //initDetector();
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      picture.value = File(pickedFile.path);
      _processImage();
    }
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
      return false;
    }
  }
}
