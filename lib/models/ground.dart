import 'package:flame/components.dart';

class Ground extends SpriteComponent with HasGameRef {
  Ground()
      : super(size: Vector2(800, 140)); // Tinggi diubah menjadi 40 (dari 20)

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('Taman4.png');
    position =
        Vector2(0, gameRef.size.y - size.y); // Tetap berada di bawah layar
  }
}
