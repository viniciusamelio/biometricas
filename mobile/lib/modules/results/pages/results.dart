import 'package:biometricas/modules/camera/dto/pictureProcessResponseDto.dart';
import 'package:biometricas/modules/camera/pages/picturePage.dart';
import 'package:biometricas/modules/results/components/resultTile.dart';
import 'package:biometricas/modules/results/controllers/resultsController.dart';
import 'package:biometricas/shared/components/button.dart';
import 'package:biometricas/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  ResultsController _controller;

  @override
  void initState() {
    _controller = ResultsController();
    _controller.getDetections();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: blue, size: 35),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: RxBuilder(
              builder: (_) {
                if (_controller.detections.value?.length == 0) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Nenhuma detecção facial salva até o momento...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withAlpha(100),
                            fontSize: 20,
                          )),
                      const SizedBox(height: 15),
                      CustomButton(
                          label: "Fazer agora!",
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home', (Route<dynamic> route) => false);
                            return Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return PicturePage();
                              },
                            ));
                          })
                    ],
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: _controller.detections.value.length,
                  itemBuilder: (_, index) {
                    final item = _controller.detections.value[index]
                        as PictureProcessResponseDto;
                    return ResultTile(imageUrl: item.imageUrl);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
