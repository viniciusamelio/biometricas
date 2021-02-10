import 'package:permission_handler/permission_handler.dart';
import 'package:rx_notifier/rx_notifier.dart';

class HomeController {
  RxNotifier<bool> cameraAccessGranted = RxNotifier(false);

  HomeController() {
    this.checkCameraPermission();
  }

  Future<void> checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isUndetermined || status.isDenied) {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.camera].request();
      cameraAccessGranted.value = statuses[0].isGranted;
    }
    cameraAccessGranted.value = status.isGranted;
  }
}
