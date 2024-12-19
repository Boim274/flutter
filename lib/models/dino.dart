import 'package:flame/components.dart';

class Dino extends SpriteComponent with HasGameRef {
  late Vector2 velocity;
  int jumpCount = 0; // Melacak jumlah lompatan
  final int maxJumpCount = 2; // Batas maksimum lompatan

  Dino() : super(size: Vector2(80, 80));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('dino.png');
    position = Vector2(50, gameRef.size.y - size.y - 140);
    velocity = Vector2(0, 0);
  }

  @override
  void update(double dt) {
    super.update(dt);
    velocity.y += 1000 * dt; // Gravitasi
    position += velocity * dt;

    // Cegah Dino keluar dari tanah
    if (position.y >= gameRef.size.y - size.y - 140) {
      position.y = gameRef.size.y - size.y - 140;
      velocity.y = 0;
      jumpCount = 0; // Reset lompatan saat di tanah
    }
  }

  void jump() {
    if (jumpCount < maxJumpCount) {
      velocity.y = -600; // Lompatan
      jumpCount++; // Tambah jumlah lompatan
    }
  }
}
