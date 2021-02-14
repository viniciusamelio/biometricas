import 'package:biometricas/shared/constants.dart';
import 'package:biometricas/shared/styles.dart';
import 'package:flutter/material.dart';

class ResultTile extends StatelessWidget {
  final String imageUrl;

  const ResultTile({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color.fromRGBO(50, 50, 50, 0.5)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              baseUrl + imageUrl,
              width: 70,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: blue, size: 45),
              Text("Aprovado", style: TextStyle(color: blue))
            ],
          ),
        ],
      ),
    );
  }
}
