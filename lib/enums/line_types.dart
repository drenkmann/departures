import 'package:flutter/material.dart';

enum LineType {
  bus(Color(0xffa5027d)),
  subway(Color(0xff004f8d)),
  suburban(Color(0xff008d4f)),
  tram(Color(0xffd82020)),
  ferry(Color(0xff0080ba)),
  regional(Color(0xffda251d)),
  express(Color(0xfff01414));

  const LineType(this.color);
  final Color color;
}
