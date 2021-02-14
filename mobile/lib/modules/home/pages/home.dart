import 'dart:ui';

import 'package:biometricas/modules/results/pages/results.dart';
import 'package:biometricas/shared/components/button.dart';
import 'package:biometricas/modules/camera/pages/picturePage.dart';
import 'package:biometricas/modules/home/controllers/homeController.dart';
import 'package:biometricas/shared/styles.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController _homeController;

  @override
  void initState() {
    _homeController = HomeController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Color.fromRGBO(22, 22, 22, 1),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/background.png'),
                alignment: Alignment.bottomCenter)),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: 50,
                ),
                const SizedBox(height: 20),
                CustomButton(
                    label: "Detecção Facial",
                    onPressed: () async {
                      await _homeController.checkCameraPermission();
                      if (_homeController.cameraAccessGranted.value) {
                        return Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return PicturePage();
                        }));
                      }
                    }),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    return Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ResultsPage();
                    }));
                  },
                  child: Text("Ver resultados",
                      style: TextStyle(
                          color: blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
