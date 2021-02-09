import 'dart:ui';

import 'package:biometricas/components/button.dart';
import 'package:biometricas/modules/camera/pages/picturePage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Color.fromRGBO(22, 22, 22, 1),
            image: DecorationImage(
                fit: BoxFit.none,
                image: AssetImage('assets/background.png'),
                alignment: Alignment.bottomCenter)),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/logo.png",
                  scale: 0.9,
                ),
                const SizedBox(height: 40),
                CustomButton(
                    label: "Detecção Facial",
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return PicturePage();
                      }));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
