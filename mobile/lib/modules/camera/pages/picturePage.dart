import 'package:biometricas/components/button.dart';
import 'package:biometricas/modules/camera/controllers/cameraController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:rx_notifier/rx_notifier.dart';

class PicturePage extends StatefulWidget {
  @override
  _PicturePageState createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  CameraController _cameraController;

  @override
  void initState() {
    _cameraController = CameraController();
    _cameraController.initDetector();
    _cameraController.foundFace.value = false;
    super.initState();
    if (_cameraController.picture.value == null) {
      _cameraController.getImage();
    }
  }

  @override
  void dispose() {
    _cameraController.faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(22, 22, 22, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: RxBuilder(builder: (_) {
            final foundFace = _cameraController.foundFace.value;
            if (_cameraController.picture.value == null) {
              return Container();
            }
            if (foundFace) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Como ficou a foto?",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 30),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_cameraController.picture.value),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Análise inicial:",
                          style: TextStyle(color: Colors.grey[200]),
                        ),
                        Icon(Icons.check_circle,
                            size: 30, color: Color.fromRGBO(20, 252, 159, 1))
                      ],
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                        label: "Tirar outra",
                        icon: Icon(Icons.camera, color: Colors.white),
                        onPressed: _cameraController.getImage),
                  ],
                ),
              );
            }
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Como ficou a foto?",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(_cameraController.picture.value),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Análise inicial:",
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                      Icon(Icons.check_circle,
                          size: 25, color: Color.fromRGBO(239, 60, 127, 1))
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(_cameraController.error.value,
                        style: TextStyle(
                            color: Colors.grey[300].withOpacity(0.7))),
                  ),
                  const SizedBox(height: 50),
                  CustomButton(
                      label: "Tirar outra",
                      icon: Icon(Icons.camera, color: Colors.white),
                      onPressed: _cameraController.getImage),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
