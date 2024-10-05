import 'package:flutter/material.dart';

enum LineType {
  bus(Color(0xffa5027d)),
  subway(Color(0xff004f8d)),
  suburban(Color(0xff008d4f));

  const LineType(this.color);
  final Color color;
}
