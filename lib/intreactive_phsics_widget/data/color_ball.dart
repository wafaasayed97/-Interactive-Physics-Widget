import 'package:flutter/material.dart';

class ColoredBall {
  final String id;
  final Color color;
  final String name;
  bool isMatched;

  ColoredBall({
    required this.id,
    required this.color,
    required this.name,
    this.isMatched = false,
  });

  ColoredBall copyWith({bool? isMatched}) {
    return ColoredBall(
      id: id,
      color: color,
      name: name,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}
