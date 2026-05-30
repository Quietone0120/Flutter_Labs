import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: TankBattleGame()));
}

class TankBattleGame extends FlameGame
    with KeyboardEvents, HasCollisionDetection {
  late PlayerTank player;
  final eagle = EagleBase();

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewfinder.zoom = 1.5;

    // Player tank (you!)
    player = PlayerTank();
    add(player);

    // Eagle base to protect 💖
    eagle.position = Vector2(400, 500);
    add(eagle);

    // Simple walls (brick = destroyable)
    add(Wall(position: Vector2(200, 300), isSteel: false));
    add(Wall(position: Vector2(250, 300), isSteel: false));
    add(Wall(position: Vector2(200, 350), isSteel: true)); // steel!

    // One enemy tank to start (more come in later levels~)
    add(EnemyTank()..position = Vector2(600, 100));

    print('🎮 Tank game loaded! Protect the Eagle~');
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    player.onKeyboard(keysPressed);
    return super.onKeyEvent(event, keysPressed);
  }
}

// ====================== PLAYER TANK ======================
class PlayerTank extends PositionComponent
    with KeyboardHandler, CollisionCallbacks {
  static const double speed = 150.0;
  Vector2 direction = Vector2(0, -1); // starts facing up
  double angle = 0;

  @override
  Future<void> onLoad() async {
    size = Vector2(40, 40);
    anchor = Anchor.center;
    add(RectangleComponent(size: size, paint: BasicPalette.white.paint()));
    add(
      RectangleComponent(
        size: Vector2(15, 30),
        position: Vector2(12.5, 5),
        paint: BasicPalette.blue.paint(),
      ),
    ); // cute cannon~
  }

  void onKeyboard(Set<LogicalKeyboardKey> keys) {
    Vector2 move = Vector2.zero();
    if (keys.contains(LogicalKeyboardKey.keyW) ||
        keys.contains(LogicalKeyboardKey.arrowUp))
      move.y -= 1;
    if (keys.contains(LogicalKeyboardKey.keyS) ||
        keys.contains(LogicalKeyboardKey.arrowDown))
      move.y += 1;
    if (keys.contains(LogicalKeyboardKey.keyA) ||
        keys.contains(LogicalKeyboardKey.arrowLeft))
      move.x -= 1;
    if (keys.contains(LogicalKeyboardKey.keyD) ||
        keys.contains(LogicalKeyboardKey.arrowRight))
      move.x += 1;

    if (move != Vector2.zero()) {
      direction = move.normalized();
      angle = direction.angleToSigned(Vector2(0, -1));
      position += move.normalized() * speed * 0.016; // smooth movement
    }

    if (keys.contains(LogicalKeyboardKey.space)) {
      shoot();
    }
  }

  void shoot() {
    final bullet = Bullet(
      position: position + direction * 30,
      direction: direction,
    );
    parent!.add(bullet);
  }

  @override
  void update(double dt) {
    super.update(dt);
    angleTo(direction); // rotate tank sprite
  }
}

// ====================== BULLET ======================
class Bullet extends PositionComponent with CollisionCallbacks {
  final Vector2 direction;
  static const speed = 400.0;

  Bullet({required Vector2 position, required this.direction})
    : super(position: position, size: Vector2(8, 8));

  @override
  Future<void> onLoad() async {
    add(CircleComponent(radius: 4, paint: BasicPalette.red.paint()));
  }

  @override
  void update(double dt) {
    position += direction * speed * dt;
    if (position.x < 0 ||
        position.x > 800 ||
        position.y < 0 ||
        position.y > 600)
      removeFromParent();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Wall || other is EnemyTank) {
      other.removeFromParent(); // destroy brick or enemy~
      removeFromParent();
    }
  }
}

// ====================== ENEMY TANK ======================
class EnemyTank extends PositionComponent with CollisionCallbacks {
  Vector2 direction = Vector2(0, 1);
  double timer = 0;

  @override
  Future<void> onLoad() async {
    size = Vector2(40, 40);
    add(RectangleComponent(size: size, paint: BasicPalette.red.paint()));
    add(
      RectangleComponent(
        size: Vector2(15, 30),
        position: Vector2(12.5, 5),
        paint: BasicPalette.red.paint(),
      ),
    );
  }

  @override
  void update(double dt) {
    timer += dt;
    position += direction * 80 * dt; // slower than player

    if (timer > 1.5) {
      // shoot at player sometimes
      final bullet = Bullet(
        position: position + direction * 30,
        direction: direction,
      );
      parent!.add(bullet);
      timer = 0;
    }
  }
}

// ====================== WALLS ======================
class Wall extends PositionComponent with CollisionCallbacks {
  final bool isSteel;
  Wall({required Vector2 position, this.isSteel = false})
    : super(position: position, size: Vector2(40, 40));

  @override
  Future<void> onLoad() async {
    final color = isSteel ? BasicPalette.gray : BasicPalette.brown;
    add(RectangleComponent(size: size, paint: color.paint()));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Bullet && !isSteel) {
      removeFromParent(); // brick destroyed~
    }
  }
}

// ====================== EAGLE BASE ======================
class EagleBase extends PositionComponent {
  @override
  Future<void> onLoad() async {
    size = Vector2(60, 60);
    add(RectangleComponent(size: size, paint: BasicPalette.yellow.paint()));
    add(
      TextComponent(
        text: '🦅',
        position: Vector2(15, 10),
        textRenderer: TextPaint(style: TextStyle(fontSize: 40)),
      ),
    );
  }
}
