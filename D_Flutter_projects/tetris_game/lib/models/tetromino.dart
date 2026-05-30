import 'package:flutter/material.dart';

enum Tetromino { I, J, L, O, S, T, Z }

class Piece {
  final Tetromino type;
  List<List<int>> shape;
  final Color color;

  Piece({required this.type})
    : shape = _getInitialShape(type),
      color = _getColor(type);

  static List<List<int>> _getInitialShape(Tetromino type) {
    switch (type) {
      case Tetromino.I:
        return [
          [1, 1, 1, 1],
        ];
      case Tetromino.J:
        return [
          [1, 0, 0],
          [1, 1, 1],
        ];
      case Tetromino.L:
        return [
          [0, 0, 1],
          [1, 1, 1],
        ];
      case Tetromino.O:
        return [
          [1, 1],
          [1, 1],
        ];
      case Tetromino.S:
        return [
          [0, 1, 1],
          [1, 1, 0],
        ];
      case Tetromino.T:
        return [
          [0, 1, 0],
          [1, 1, 1],
        ];
      case Tetromino.Z:
        return [
          [1, 1, 0],
          [0, 1, 1],
        ];
    }
  }

  static Color _getColor(Tetromino type) {
    switch (type) {
      case Tetromino.I:
        return const Color(0xFF00f0f0);
      case Tetromino.J:
        return const Color(0xFF0000f0);
      case Tetromino.L:
        return const Color(0xFFf0a000);
      case Tetromino.O:
        return const Color(0xFFf0f000);
      case Tetromino.S:
        return const Color(0xFF00f000);
      case Tetromino.T:
        return const Color(0xFFa000f0);
      case Tetromino.Z:
        return const Color(0xFFf00000);
    }
  }

  void rotate() {
    List<List<int>> newShape = List.generate(
      shape[0].length,
      (j) => List.generate(shape.length, (i) => shape[shape.length - 1 - i][j]),
    );
    shape = newShape;
  }
}
