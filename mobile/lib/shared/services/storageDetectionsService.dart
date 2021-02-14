import 'package:biometricas/modules/camera/dto/pictureProcessResponseDto.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class StorageDetectionsService {
  Box box;

  StorageDetectionsService() {
    openBox();
  }

  openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox("detections");
  }

  saveDetection(PictureProcessResponseDto detection) {
    box.put(detection.imageUrl, detection.toJson());
  }

  getDetections() async {
    await openBox();
    var detections = box.values;
    final list = [];
    for (var item in detections.toList().reversed) {
      list.add(PictureProcessResponseDto.fromJson(item));
    }
    return list;
  }
}
