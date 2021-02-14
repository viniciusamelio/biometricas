import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final Icon icon;
  final String label;
  const CustomButton(
      {Key key, @required this.onPressed, this.icon, @required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      textColor: Colors.white,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Ink(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color.fromRGBO(0, 249, 232, 1),
                  Color.fromRGBO(7, 196, 203, 1),
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(4))),
          padding:
              const EdgeInsets.only(top: 12, bottom: 12, left: 80, right: 40),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label ?? 'Texto',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
              const SizedBox(width: 40),
              icon ?? const Icon(Icons.arrow_forward)
            ],
          ),
        ),
      ),
    );
  }
}
