import 'package:flame/components.dart';

class Ground extends SpriteComponent with HasGameRef {
  Ground()
      : super(size: Vector2(800, 120)); // Tinggi diubah menjadi 40 (dari 20)

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('Plan 5.png');
    position =
        Vector2(0, gameRef.size.y - size.y); // Tetap berada di bawah layar
  }
}
