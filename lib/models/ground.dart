import 'package:flame/components.dart';

class Ground extends SpriteComponent with HasGameRef {
  Ground() : super(size: Vector2(800, 20));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('Plan 5.png');
    position = Vector2(0, gameRef.size.y - size.y);
  }
}
