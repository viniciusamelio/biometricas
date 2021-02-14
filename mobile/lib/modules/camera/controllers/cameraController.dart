import 'dart:io';

import 'package:biometricas/modules/camera/dto/pictureProcessRequestDto.dart';
import 'package:biometricas/modules/camera/dto/pictureProcessResponseDto.dart';
import 'package:biometricas/modules/camera/repositories/cameraRepository.dart';
import 'package:biometricas/modules/camera/services/faceDetector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rx_notifier/rx_notifier.dart';

class CameraController {
  final _picker = ImagePicker();
  final _repository = CameraRepository();
  final _faceDetectorService = FaceDetectorService();

  RxNotifier<bool> loading = RxNotifier(false);
  RxNotifier<bool> isRequestRunning = RxNotifier(false);
  RxNotifier<File> picture = RxNotifier(null);
  RxNotifier<bool> foundFace = RxNotifier(false);
  RxNotifier<String> error = RxNotifier("");

  double percentage;

  PictureProcessRequestDto _requestDto = PictureProcessRequestDto();

  initDetector() {
    _faceDetectorService.initDetector();
  }

  closeDetector() {
    _faceDetectorService.faceDetector.close();
  }

  _setRequestDto() {
    _requestDto.file = picture.value;
    _requestDto.percentage = percentage ?? 99;
  }

  getImage() async {
    loading.value = true;
    final pickedFile = await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 1920,
        maxWidth: 1080);
    if (pickedFile != null) {
      picture.value = File(pickedFile.path);
      await _faceDetectorService.processImage(
          picture.value, foundFace, percentage, error);
    }
    loading.value = false;
  }

  Future<PictureProcessResponseDto> submitImage() async {
    _setRequestDto();
    isRequestRunning.value = true;
    final response = await _repository.process(_requestDto);
    isRequestRunning.value = false;
    return response;
  }
}
