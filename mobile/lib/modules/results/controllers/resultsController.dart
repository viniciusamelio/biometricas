import 'package:biometricas/shared/services/StorageDetectionsService.dart';
import 'package:rx_notifier/rx_notifier.dart';

class ResultsController {
  final _storageService = StorageDetectionsService();

  RxNotifier<List<dynamic>> detections = RxNotifier([]);

  getDetections() async {
    detections.value = await _storageService.getDetections();
  }
}
