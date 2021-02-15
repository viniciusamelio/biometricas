import 'package:biometricas/modules/results/pages/results.dart';
import 'package:biometricas/shared/components/button.dart';
import 'package:biometricas/modules/camera/controllers/cameraController.dart';
import 'package:biometricas/shared/services/storageDetectionsService.dart';
import 'package:biometricas/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class PicturePage extends StatefulWidget {
  @override
  _PicturePageState createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  CameraController _cameraController;
  final _storageDetectionService = StorageDetectionsService();

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
    _cameraController.closeDetector();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: blue, size: 35),
      ),
      backgroundColor: Color.fromRGBO(22, 22, 22, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: RxBuilder(builder: (_) {
              final foundFace = _cameraController.foundFace.value;
              if (_cameraController.loading.value ||
                  _cameraController.isRequestRunning.value) {
                return Column(
                  children: [
                    CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text("Carregando...")
                  ],
                );
              }
              if (_cameraController.picture.value == null) {
                return CustomButton(
                  label: "Detectar Face",
                  onPressed: _cameraController.getImage,
                );
              }
              if (foundFace) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Como ficou a foto?",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 30),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _cameraController.picture.value,
                        width: MediaQuery.of(context).size.width * 0.7,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Resultado:",
                            style: TextStyle(color: Colors.grey[200]),
                          ),
                          Icon(Icons.check_circle,
                              size: 30, color: Color.fromRGBO(20, 252, 159, 1))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.14),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(_cameraController.feedback.value,
                            style: TextStyle(
                                color: Colors.grey[300].withOpacity(0.7))),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                        label: "Tirar outra",
                        icon: Icon(Icons.camera, color: Colors.white),
                        onPressed: _cameraController.getImage),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () async {
                        final response = await _cameraController.submitImage();
                        if (response.error != null) {
                          return showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message: response.error.toString() ??
                                  "Ocorreu um erro",
                            ),
                          );
                        }
                        _storageDetectionService.saveDetection(response);

                        showTopSnackBar(
                            context,
                            CustomSnackBar.success(
                              message: response.message + " !!" ??
                                  "Enviado com sucesso!",
                            ),
                            displayDuration: Duration(seconds: 2));
                        _cameraController.loading.value = true;
                        await Future.delayed(Duration(seconds: 2));
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/home', (Route<dynamic> route) => false);
                        return Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ResultsPage();
                        }));
                      },
                      child: Text("Gostei, enviar",
                          style: TextStyle(
                              fontSize: 17,
                              color: blue,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Como ficou a foto?",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 30),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_cameraController.picture.value,
                          width: MediaQuery.of(context).size.width * 0.7)),
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Resultado:",
                          style: TextStyle(color: Colors.grey[200]),
                        ),
                        Icon(Icons.check_circle,
                            size: 25, color: Color.fromRGBO(239, 60, 127, 1))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.14),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(_cameraController.feedback.value,
                          style: TextStyle(
                              color: Colors.grey[300].withOpacity(0.7))),
                    ),
                  ),
                  const SizedBox(height: 50),
                  CustomButton(
                      label: "Tirar outra",
                      icon: Icon(Icons.camera, color: Colors.white),
                      onPressed: _cameraController.getImage),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
