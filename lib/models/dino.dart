import 'package:flame/components.dart';

class Dino extends SpriteComponent with HasGameRef {
  late Vector2 velocity;

  Dino() : super(size: Vector2(80, 80));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('dino.png');
    position = Vector2(50, gameRef.size.y - size.y - 20);
    velocity = Vector2(0, 0);
  }

  @override
  void update(double dt) {
    super.update(dt);
    velocity.y += 1000 * dt; // Gravitasi
    position += velocity * dt;

    // Cegah Dino keluar dari tanah
    if (position.y >= gameRef.size.y - size.y - 120) {
      position.y = gameRef.size.y - size.y - 120;
      velocity.y = 0;
    }
  }

  void jump() {
    if (position.y >= gameRef.size.y - size.y - 120) {
      velocity.y = -600; // Lompatan
    }
  }
}
