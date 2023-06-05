import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppText extends StatelessWidget {
  final Color? color;
  final String text;
  double size;
  TextOverflow overflow;

  AppText({super.key, 
  this.color, 
  required this.text,
  this.size =15,
  this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      //it will create only one line.
      maxLines: 1,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
    );
  }
}