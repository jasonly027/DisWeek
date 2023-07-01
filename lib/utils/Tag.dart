import 'package:flutter/material.dart';
import 'package:dis_week/utils/Database.dart';

const String tableTags = 'tags';

class TagFields {
  static const List<String> columns = [
    id,
    name,
    color,
    globalOrder,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String color = 'color';
  static const String globalOrder = 'globalOrder';
}

class Tag {
  int? id;
  String? name;
  Color color;
  int? globalOrder;

  Tag({this.id, this.name, required this.color, this.globalOrder});

  Tag copy({int? id, String? name, Color? color, int? globalOrder}) => Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      globalOrder: globalOrder ?? this.globalOrder);

  Tag.fromJson(Map<String, dynamic> json)
      : id = json[TagFields.id] as int?,
        name = json[TagFields.name] as String?,
        color = Color(json[TagFields.color]),
        globalOrder = json[TagFields.globalOrder] as int?;

  Map<String, dynamic> toJson() => {
        TagFields.id : id,
        TagFields.name : name,
        TagFields.color : color.value,
        TagFields.globalOrder : globalOrder
      };

  bool equals(Tag other) {
    return id == other.id;
  }
}
