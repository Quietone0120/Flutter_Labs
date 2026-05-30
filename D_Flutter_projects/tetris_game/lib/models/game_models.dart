import 'package:flutter/material.dart';

// Game Constants
const int BOARD_WIDTH = 10;
const int BOARD_HEIGHT = 20;
const int BLOCK_SIZE = 30;

// Tetromino pieces
class Piece {
  final String name;
  final Color color;
  final List<List<int>> shape;
  int rotation;

  Piece({
    required this.name,
    required this.color,
    required this.shape,
    this.rotation = 0,
  });

  List<List<int>> getRotatedShape() {
    if (rotation == 0) return shape;

    List<List<int>> rotated = List.from(shape);
    for (int i = 0; i < rotation; i++) {
      rotated = _rotateClockwise(rotated);
    }
    return rotated;
  }

  List<List<int>> _rotateClockwise(List<List<int>> original) {
    int rows = original.length;
    int cols = original[0].length;

    List<List<int>> rotated = List.generate(
      cols,
      (i) => List.generate(rows, (j) => 0),
    );

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        rotated[j][rows - 1 - i] = original[i][j];
      }
    }

    return rotated;
  }

  Piece copyWith({int? rotation}) {
    return Piece(
      name: name,
      color: color,
      shape: List.from(shape),
      rotation: rotation ?? this.rotation,
    );
  }
}

// Define all Tetromino pieces
class PieceFactory {
  static final Map<String, Piece> pieces = {
    'I': Piece(
      name: 'I',
      color: const Color(0xFF00F0F0),
      shape: [
        [1, 1, 1, 1],
      ],
    ),
    'O': Piece(
      name: 'O',
      color: const Color(0xFFF0F000),
      shape: [
        [1, 1],
        [1, 1],
      ],
    ),
    'T': Piece(
      name: 'T',
      color: const Color(0xFFA000F0),
      shape: [
        [0, 1, 0],
        [1, 1, 1],
      ],
    ),
    'L': Piece(
      name: 'L',
      color: const Color(0xFFF0A000),
      shape: [
        [1, 0],
        [1, 0],
        [1, 1],
      ],
    ),
    'J': Piece(
      name: 'J',
      color: const Color(0xFF0000F0),
      shape: [
        [0, 1],
        [0, 1],
        [1, 1],
      ],
    ),
    'S': Piece(
      name: 'S',
      color: const Color(0xFF00F000),
      shape: [
        [0, 1, 1],
        [1, 1, 0],
      ],
    ),
    'Z': Piece(
      name: 'Z',
      color: const Color(0xFFF00000),
      shape: [
        [1, 1, 0],
        [0, 1, 1],
      ],
    ),
  };

  static Piece getRandomPiece() {
    final pieceList = pieces.values.toList();
    pieceList.shuffle();
    return pieceList.first;
  }
}

// Game board state
class GameBoard {
  late List<List<int>> grid;
  late Piece currentPiece;
  late int currentX;
  late int currentY;
  late Piece nextPiece;
  int score = 0;
  int lines = 0;
  bool gameOver = false;
  bool isPaused = false;

  GameBoard() {
    reset();
  }

  void reset() {
    grid = List.generate(
      BOARD_HEIGHT,
      (_) => List.generate(BOARD_WIDTH, (_) => 0),
    );
    currentPiece = PieceFactory.getRandomPiece();
    currentX = BOARD_WIDTH ~/ 2 - 1;
    currentY = 0;
    nextPiece = PieceFactory.getRandomPiece();
    score = 0;
    lines = 0;
    gameOver = false;
    isPaused = false;
  }

  bool canMove(int newX, int newY, Piece piece) {
    final shape = piece.getRotatedShape();

    for (int y = 0; y < shape.length; y++) {
      for (int x = 0; x < shape[y].length; x++) {
        if (shape[y][x] == 1) {
          int boardX = newX + x;
          int boardY = newY + y;

          if (boardX < 0 || boardX >= BOARD_WIDTH || boardY >= BOARD_HEIGHT) {
            return false;
          }

          if (boardY >= 0 && grid[boardY][boardX] != 0) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void rotatePiece() {
    final newRotation = (currentPiece.rotation + 1) % 4;
    final rotatedPiece = currentPiece.copyWith(rotation: newRotation);

    if (canMove(currentX, currentY, rotatedPiece)) {
      currentPiece = rotatedPiece;
    }
  }

  void moveLeft() {
    if (canMove(currentX - 1, currentY, currentPiece)) {
      currentX--;
    }
  }

  void moveRight() {
    if (canMove(currentX + 1, currentY, currentPiece)) {
      currentX++;
    }
  }

  bool moveDown() {
    if (canMove(currentX, currentY + 1, currentPiece)) {
      currentY++;
      return true;
    }
    return false;
  }

  void lockPiece() {
    final shape = currentPiece.getRotatedShape();

    for (int y = 0; y < shape.length; y++) {
      for (int x = 0; x < shape[y].length; x++) {
        if (shape[y][x] == 1) {
          int boardY = currentY + y;
          int boardX = currentX + x;

          if (boardY >= 0 &&
              boardY < BOARD_HEIGHT &&
              boardX >= 0 &&
              boardX < BOARD_WIDTH) {
            grid[boardY][boardX] = 1;
          } else if (boardY < 0) {
            gameOver = true;
          }
        }
      }
    }

    clearLines();
    spawnNewPiece();
  }

  void clearLines() {
    int clearedLines = 0;

    for (int y = BOARD_HEIGHT - 1; y >= 0; y--) {
      bool isComplete = true;
      for (int x = 0; x < BOARD_WIDTH; x++) {
        if (grid[y][x] == 0) {
          isComplete = false;
          break;
        }
      }

      if (isComplete) {
        grid.removeAt(y);
        grid.insert(0, List.generate(BOARD_WIDTH, (_) => 0));
        clearedLines++;
        y++;
      }
    }

    if (clearedLines > 0) {
      lines += clearedLines;
      score += clearedLines * clearedLines * 100;
    }
  }

  void spawnNewPiece() {
    currentPiece = nextPiece;
    nextPiece = PieceFactory.getRandomPiece();
    currentX = BOARD_WIDTH ~/ 2 - 1;
    currentY = 0;

    if (!canMove(currentX, currentY, currentPiece)) {
      gameOver = true;
    }
  }
}
