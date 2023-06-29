import 'package:flutter/material.dart';

class Tag {
  String? name;
  Color color;

  Tag({this.name, required this.color});

  bool equals(Tag other) {
    return name == other.name && color == other.color;
  }
}
